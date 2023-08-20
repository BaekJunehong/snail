import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  bool _isButtonDisabled = true;
  late CameraController _controller;
  bool cameraIsOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    // 사용 가능한 카메라 목록 가져오기
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // 카메라 컨트롤러 초기화
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    // 카메라 컨트롤러 초기화 완료 대기
    cameraIsOn = true;

    if (mounted) {
      setState(() {}); // 상태 갱신
    }

    Future<void> sendFaceImg() async {
      Future.delayed(const Duration(milliseconds: 20), () async {
        XFile image = await _controller.takePicture();
        
        final byteData = await convertImageToJpeg(image);

        // 서버로 이미지 전송
        var request = http.MultipartRequest('POST', Uri.parse('ec2-43-202-125-41.ap-northeast-2.compute.amazonaws.com:3033/faceRecognize'));
        request.files.add(http.MultipartFile.fromBytes(
          'image', 
          byteData, 
          filename: 'face.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
        var response = await request.send();

        // response 코드

        sendFaceImg();
      });
    }
    sendFaceImg();
  }
  
  Future<Uint8List> convertImageToJpeg(XFile image) async {
    final bytes = await image.readAsBytes();
    return bytes;
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
