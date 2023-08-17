import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

void main() => runApp(Audio2Text(gameTime: 5,));

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onRecordDone;
  final int gameTime;
  const AudioRecorder({Key? key, required this.onRecordDone, required this.gameTime}) : super(key: key);

  @override
  State<AudioRecorder> createState() => _AudioRecorderState(onRecordDone, gameTime);
}

class _AudioRecorderState extends State<AudioRecorder> {
  final _audioRecorder = Record();
  final void Function(String path) onRecordDone;
  bool _isRecording = false;
  final int gameTime;

  _AudioRecorderState(this.onRecordDone, this.gameTime);

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
    var _speech = stt.SpeechToText();
    void _listen() async {
      await _speech.initialize();
      if (!_isRecording) {
        await _recordstart();
      }
      await _speech.listen(
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 2),
        cancelOnError: false,
        partialResults: true,
        onResult: (result) async {
          //print(result);
          if (result.finalResult) {
            await _recordstop();
          }
        },
      );
    }
    int popTime = 0;
    Timer.periodic(Duration(seconds: 1), (timer) async {
      popTime++;
      if (popTime >= gameTime) {
        timer.cancel();
        Navigator.pop(context);
      }
      else if (!_speech.isListening) {
        _recordstop();
        _listen();
      }
    });
  }

  // 녹음 시작
  Future<void> _recordstart() async {
    await _audioRecorder.start();
    setState(() => _isRecording = true);
  }

  // 녹음 중지
  Future<void> _recordstop() async {
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

class Audio2Text extends StatelessWidget {
  final int gameTime;
  Audio2Text({required this.gameTime, Key? key}) : super(key: key);

  final StreamController<String> _responseController = StreamController<String>();
  
  // 서버로 음성 데이터 전달 및 해당하는 텍스트 받아오기
  Future<void> _postAudio(String path) async {
    //print('Recorded file path: $path');
    String text = '';
    var url = Uri.http('ec2-43-202-125-41.ap-northeast-2.compute.amazonaws.com:3033', '/audioRecognition');

    // 웹
    if (kIsWeb) {
      final request = html.HttpRequest();
      request.open('GET', path, async: true);
      request.responseType = 'blob';
      request.onLoadEnd.listen((event) {
        final blob = request.response as html.Blob;

        final reader = html.FileReader();
        reader.readAsArrayBuffer(blob);

        reader.onLoadEnd.listen((event) async {
          final buffer = reader.result as Uint8List;
          final encoded = base64Encode(buffer);

          var response = await http.post(url, body: {'audio': encoded});
          _responseController.add(text);
          text = response.body;
        });
      });
      request.send();
  } 
    // 앱
    else {
      var bytes = await File(path).readAsBytes();
      var encoded = base64Encode(bytes);

      var response = await http.post(url, body: {'audio': encoded});
      _responseController.add(text);
      text = response.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AudioRecorder(
          onRecordDone: (path) => _postAudio(path), gameTime: gameTime
        )
      ),
    );
  }
}