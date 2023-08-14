import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  final _speech = stt.SpeechToText();
  final void Function(String path) onRecordDone;
  bool _isRecording = false;

  _AudioRecorderState(this.onRecordDone);

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 마이크 권한 요청 및 음성 크기 변경 감지
    _initialize();
  }

  Future<void> _initialize() async {
    await _requestPermission();
    await _initializeSpeechRecognition();
  }

  // 마이크 권한 요청
  Future<void> _requestPermission() async {
    if (kIsWeb) {
      // 웹 환경에서 마이크 권한 요청
      await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
    } else {
      // 모바일 환경에서 마이크 권한 요청
      await Permission.microphone.request();
    }
  }

  Future<void> _initializeSpeechRecognition() async {
    await _speech.initialize();
    await _speech.listen(
      listenFor: Duration(seconds: 300),
      pauseFor: Duration(seconds: 2),
      onResult: (result) {
        print(result);
        if (!_isRecording) {
          _start();
        }
        if (result.finalResult) {
          _stop();
        }
      },
    );
  }

  // 녹음 시작
  Future<void> _start() async {
    await _audioRecorder.start();
    setState(() => _isRecording = true);
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
