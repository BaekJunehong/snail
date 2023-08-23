import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snail/tests/tests/follow_the_words.dart';
import 'package:just_audio/just_audio.dart';

class VocaRepeatGuideScreen extends StatefulWidget {
  @override
  _VocaRepeatGuideScreenState createState() => _VocaRepeatGuideScreenState();
}

class _VocaRepeatGuideScreenState extends State<VocaRepeatGuideScreen> {
  final player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    guideVoice();
    Future.delayed(Duration(seconds: 10), () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => followTest()),
      );
      Navigator.pop(context, result);
    });
  }

  Future<void> guideVoice() async {
    await player.setAsset('assets/sounds/test_name/repeat.wav');
    await player.play();

    await player.processingStateStream.firstWhere((state) => state == ProcessingState.completed);
    await Future.delayed(Duration(seconds: 1));
  
    await player.setAsset('assets/sounds/guide/repeat.wav');
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
                      '단어 따라 말하기',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '소요 시간: 03분',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '들려주는 단어를 듣고, 들은 순서대로 단어들을 기억해주세요!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      'assets/voca_rp.png',
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
