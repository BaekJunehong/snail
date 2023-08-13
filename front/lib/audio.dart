import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'dart:js' as js;
import 'dart:html' as html;

void main() => runApp(const MyApp());

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onRecordDone;

  const AudioRecorder({Key? key, required this.onRecordDone}) : super(key: key);

  @override
  State<AudioRecorder> createState() => _AudioRecorderState(onRecordDone);
}

class _AudioRecorderState extends State<AudioRecorder> {
  final _audioRecorder = Record();
  late StreamSubscription<html.Event> _audioInputSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;
  final void Function(String path) onRecordDone;
  bool _isRecording = false;

  _AudioRecorderState(this.onRecordDone);

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 마이크 권한 요청
    _requestPermission();
    // 음성 크기 변경 감지 - Web
    if ((kIsWeb)) {
      _audioInputSub = html.window.on['audio'].listen((event) {
        final input = js.JsObject.fromBrowserObject(event)['input'];
        print(input);
        if (input > -160 && !_isRecording) {
          // 음성 크기가 임계값보다 큰 경우 녹음 시작
          _start();
        } else if (input <= -161 && _isRecording) {
          // 음성 크기가 임계값보다 작은 경우 녹음 중지
          _stop();
        }
      });
    }
    // 음성 크기 변경 감지 - App
    else {
      _amplitudeSub = _audioRecorder
          .onAmplitudeChanged(const Duration(milliseconds: 300))
          .listen((amp) {
        setState(() => _amplitude = amp);
        if (_amplitude != null && _amplitude!.current > -160 && !_isRecording) {
          // 음성 크기가 임계값보다 큰 경우 녹음 시작
          _start();
        } else if (_amplitude != null && _amplitude!.current <= -161 && _isRecording) {
          // 음성 크기가 임계값보다 작은 경우 녹음 중지
          _stop();
        }
      });
    }
  }

  // 마이크 권한 요청
  Future<void> _requestPermission() async {
    if (kIsWeb) {
      // 웹 환경에서 마이크 권한 요청
      try {
        await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      // 모바일 환경에서 마이크 권한 요청
      await Permission.microphone.request();
    }
  }

  // 녹음 시작
  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }
        await _audioRecorder.start();
        setState(() => _isRecording = true);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // 녹음 중지
  Future<void> _stop() async {
    final path = await _audioRecorder.stop();
    setState(() => _isRecording = false);
    if (path != null) {
      onRecordDone(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // UI가 필요하지 않으므로 빈 컨테이너 반환
  }

  @override
  void dispose() {
    _audioInputSub.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AudioRecorder(
          onRecordDone: (path) {
            // 여기에서 녹음된 음성 파일 처리
            print('Recorded file path: $path');
          },
        ),
      ),
    );
  }
}
