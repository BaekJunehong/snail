import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class FaceImgSender {
  CameraController controller;
  bool _isSending = false;
  int _count = 0;

  FaceImgSender(this.controller);

  Future<void> startSending() async {
    _isSending = true;
    _count = 0;
    sendFaceImg();
  }

  int stopSending() {
    _isSending = false;
    return _count;
  }

  Future<void> sendFaceImg() async {
    if (!_isSending) return;

    Future.delayed(const Duration(milliseconds: 20), () async {
      XFile image = await controller.takePicture();
      
      final byteData = await convertImageToJpeg(image);

      // 서버로 이미지 전송
      var request = http.MultipartRequest('POST', Uri.http('ec2-43-202-125-41.ap-northeast-2.compute.amazonaws.com:3033', 'faceRecognize'));
      request.files.add(http.MultipartFile.fromBytes(
        'image', 
        byteData, 
        filename: 'face.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
      var response = await request.send();

      response.stream.listen((value) {
        print(value);
      });

      sendFaceImg();
    });
  }

  Future<Uint8List> convertImageToJpeg(XFile image) async {
    final bytes = await image.readAsBytes();
    return bytes;
  }
}

Future<CameraController> initializeCamera() async {
  // 사용 가능한 카메라 목록 가져오기
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  // 카메라 컨트롤러 초기화
  CameraController _controller = CameraController(
    firstCamera,
    ResolutionPreset.medium,
  );
  await _controller.initialize();
  // 카메라 컨트롤러 초기화 완료 대기

  return _controller;
}
