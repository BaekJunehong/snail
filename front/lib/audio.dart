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

String text = '';
Function(String)? onTextChanged;

class AudioRecorder extends StatefulWidget {
  bool isRecordable;
  int testTime;
  AudioRecorder({Key? key, required this.isRecordable, required this.testTime}) : super(key: key);
  
  @override
  State<AudioRecorder> createState() => _AudioRecorderState(isRecordable, testTime);
}

class _AudioRecorderState extends State<AudioRecorder> {
  final _audioRecorder = Record();
  bool isRecordable;
  int testTime;

  _AudioRecorderState(this.isRecordable, this.testTime);

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
      await _recordstart();
      await _speech.listen(
        listenFor: Duration(seconds: 1000),
        pauseFor: Duration(seconds: 1000),
        cancelOnError: false,
        partialResults: true,
        onResult: (result) async {
          print(result);
          if (result.finalResult) {
            await _recordstop();
          }
        },
      );
    }
    _listen();

    int popTime = 0;
    Timer.periodic(Duration(seconds: 1), (timer) async{ 
      popTime++;
      if (popTime >= testTime) {
        timer.cancel();
        await _recordstop();
      }
    });
  }

  // 녹음 시작
  Future<void> _recordstart() async {
    await _audioRecorder.start();
    setState(() {});
  }

  // 녹음 중지
  Future<void> _recordstop() async {
    final path = await _audioRecorder.stop();
    setState(() {});
    if (path != null) {
      _postAudio(path);
    }
  }

  Future<void> _postAudio(String path) async {
    //print('Recorded file path: $path');

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
          text = response.body;
          print(text);
          //onTextChanged!(text);
        });
      });
      request.send();
  } 
    // 앱
    else {
      var bytes = await File(path).readAsBytes();
      var encoded = base64Encode(bytes);

      var response = await http.post(url, body: {'audio': encoded});
      text = response.body;
      onTextChanged!(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // UI가 필요하지 않으므로 빈 컨테이너 반환
  }
}