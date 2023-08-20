import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:async';

class BeforeTestGuideScreen extends StatefulWidget {
  @override
  _BeforeTestGuideScreenState createState() => _BeforeTestGuideScreenState();
}

class _BeforeTestGuideScreenState extends State<BeforeTestGuideScreen> {
  bool isPermitted = false;
  Timer? _timer;

  Future<void> _requestPermission() async {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (kIsWeb) {
        // 웹 환경
        // 카메라, 마이크 권한 요청
        try {
          await html.window.navigator.getUserMedia(audio: true, video: true); 
          isPermitted = true;
        } catch (e) {
          print("Permission denied: $e");
          isPermitted = false;
        }
      } 
      else {
        // 모바일 환경
        // 마이크 권한 요청
        var status = await Permission.microphone.request();
        isPermitted = status.isGranted;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/pattern.png', fit: BoxFit.fill),
          ),
          Center(
            child: Container(
              //모달
              width: 862,
              height: 554,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // 텍스트를 왼쪽으로 정렬
                  children: [
                    Center(
                      child: Center(
                        child: Text(
                          '꼭 확인해주세요!',
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      'assets/okay.png',
                      width: 300,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        '1. 원활한 게임 진행을 위해 기기는 가로로 사용해주세요!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        '2. 마이크와 카메라를 사용할 수 있도록 권한을 허용해주세요!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        '3. AI 얼굴 인식을 위해 밝고 잡음이 없는 환경에서 게임을 진행해주세요!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: isPermitted ? () {
                        // 검사 전 가이드로 이동.
                        Navigator.pop(context, 0);
                      } : null,
                      child: Text(
                        '시작하기',
                        style:
                            TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFffcb39),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        fixedSize: Size(165, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
