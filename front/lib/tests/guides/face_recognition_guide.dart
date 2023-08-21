import 'package:flutter/material.dart';
import 'package:snail/tests/eyetracking.dart';
import 'package:camera/camera.dart';

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  bool _isButtonDisabled = false;
  late CameraController _controller;
  bool cameraIsOn = false;

  @override
  void initState() {
    super.initState();
    openCamera();
  }

  Future<void> openCamera() async {
    _controller = await initializeCamera();
    cameraIsOn = true;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '아이의 얼굴 정면이 잘 나오도록 해주세요!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 872, // 카메라 화면 너비 설정
              height: 539, // 카메라 화면 높이 설정
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // 테두리 색상 설정
                  width: 3, // 테두리 두께 설정
                ),
              ),
              child: cameraIsOn ? CameraPreview(_controller) : Container(), // 카메라 화면을 표시하는 위젯
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                // 검사 전 가이드로 이동.
                Navigator.pop(context, 0);
              },
              child: Text(
                '시작하기',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                primary:
                    _isButtonDisabled ? Color(0XFFd9d9d9) : Color(0XFFffcb39),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                fixedSize: Size(165, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
