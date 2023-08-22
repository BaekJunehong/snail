import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snail/tests/tests/stroop_test.dart';
import 'package:just_audio/just_audio.dart';


class StroopGuideScreen extends StatefulWidget {
  @override
  _StroopGuideScreenState createState() => _StroopGuideScreenState();
}

class _StroopGuideScreenState extends State<StroopGuideScreen> {
  final player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    guideVoice();
    Future.delayed(Duration(seconds: 10), () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StroopTest()),
      );
      Navigator.pop(context, result);
    });
  }

  Future<void> guideVoice() async {
    await player.setAsset('assets/sounds/guide/stroop.wav');
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
                      '스트룹 검사',
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
                      '그림과 같이 단어가 표시될 때, 단어의 색깔을 말해주세요!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      'assets/stroop.png',
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
