import 'package:flutter/material.dart';
import 'package:snail/tests/guides/backspace_guide.dart';
import 'package:snail/tests/tests/story_test/story_video.dart';
import 'package:just_audio/just_audio.dart';

class StoryGuideScreen extends StatefulWidget {
  @override
  _StoryGuideScreenState createState() => _StoryGuideScreenState();
}

class _StoryGuideScreenState extends State<StoryGuideScreen> {
  final player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoryTest()),
      );
      Navigator.pop(context, result);
    });
  }

  Future<void> guideVoice() async {
    await player.setAsset('assets/sounds/guide/story.wav');
    await player.play();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/pattern.png', fit: BoxFit.fill),
          ),
          Center(
            child: Container(
              //모달
              width: 862,
              height: 554,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '이야기 이해하기',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '소요 시간: 10분',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '이야기 영상을 보고, 문제에 대한 답을 말해주세요!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      'assets/story.png',
                      width: 478,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
