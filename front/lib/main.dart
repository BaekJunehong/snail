import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snail/splash.dart';
import 'package:snail/test/chosung_test.dart';
import 'package:snail/tests/result/dashboard/parentnote.dart';
import 'package:snail/test/stroop_test.dart';
import 'package:snail/test/line_test.dart';
import 'package:snail/test/follow_the_words.dart';
=======
import 'package:snail/tests/result/noresults.dart';
>>>>>>> da49a3e65ea181f2b902837dc262379687cfaf45

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
      title: 'SNaiL',
      home: Scaffold(
<<<<<<< HEAD
        body: followTest(),
=======
        body: NoResultScreen(),
>>>>>>> da49a3e65ea181f2b902837dc262379687cfaf45
      ), //처음 접하는 화면을 SplashScreen으로 설정.
    );
  }
}
