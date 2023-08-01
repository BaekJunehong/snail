import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//결과 관련해서는 데이터 팀 작업 및 DB 개발 후 진행해주세요!

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //작업 내용
    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/logo.svg'),
      ),
    );
  }
}
