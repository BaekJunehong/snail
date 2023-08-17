import 'package:flutter/material.dart';
import 'package:snail/tests/tests/story_test/story_test.dart';
import 'package:snail/tests/test/story_test.dart';

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
        body: StoryTestScreen(),
      ), //처음 접하는 화면을 SplashScreen으로 설정.
    );
  }
}
