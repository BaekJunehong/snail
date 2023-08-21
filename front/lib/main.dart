import 'package:flutter/material.dart';
import 'package:snail/tests/tests/story_test/story_video.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
      title: 'SNaiL',
      home: Scaffold(
        body: StoryTest(),
      ), //처음 접하는 화면을 SplashScreen으로 설정.
    );
  }
}
