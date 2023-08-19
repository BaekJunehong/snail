import 'package:flutter/material.dart';

class correctSign extends StatefulWidget {
  @override
  _correctSignState createState() => _correctSignState();
}

class _correctSignState extends State<correctSign> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    // 1초 후에 _isVisible을 false로 변경하여 위젯을 숨깁니다.
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Center(
            child: Image.asset(
              'assets/correct.png', // 이미지 파일의 경로를 설정합니다. assets 폴더에 이미지 파일이 있어야 합니다.
              width: 400, // 이미지의 가로 크기를 설정합니다.
              height: 400, // 이미지의 세로 크기를 설정합니다.
            ),
          )
        : Container();
  }
}
