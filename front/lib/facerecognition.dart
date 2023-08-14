import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // camera 패키지를 추가해야 합니다.

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  bool _isButtonDisabled = true;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // 사용 가능한 카메라 목록 가져오기
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // 카메라 컨트롤러 초기화
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    // 카메라 컨트롤러 초기화 완료 대기
    await _controller.initialize();

    if (mounted) {
      setState(() {}); // 상태 갱신
    }
  }

  void startRecognition() {
    //얼굴 인식 등록되면 버튼 활성화
    //DB에 얼굴 인식 저장? 일단 자녀 선택 프로필로 이동
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        _isButtonDisabled = false; //버튼 활성화
      });
      Navigator.pushReplacementNamed(context, '/starttest'); //검사 시작 전 화면으로 이동
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
              child: CameraPreview(_controller), // 카메라 화면을 표시하는 위젯
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _isButtonDisabled ? null : startRecognition,
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
