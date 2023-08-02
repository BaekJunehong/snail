import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snail/login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //스플래시 화면이 3초 동안 나타난 다음 메인 화면으로 이동
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ));
    });

    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/logo.svg'),
      ),
    );
  }
}
