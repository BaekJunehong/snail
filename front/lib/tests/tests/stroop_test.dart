import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:snail/tests/correct_sign.dart';
import 'package:snail/tests/count_down.dart';

class StroopTest extends StatefulWidget {
  @override
  _StroopTestState createState() => _StroopTestState();
}

class _StroopTestState extends State<StroopTest> {
  List<List<String>> words = [
    ['빨강', '파랑', 'blue'],
    ['파랑', '노랑', 'yellow'],
    ['노랑', '빨강', 'red'],
    ['초록', '보라', 'purple'],
    ['보라', '초록', 'green']
  ];

  //정답처리 관련 변수
  int randIndex = 0;
  TextEditingController answerController = TextEditingController();
  int correctCount = 0;
  bool isCorrected = false;

  //countdown 관련 변수
  bool isVisible = true;
  int countdownSeconds = 3; // Countdown seconds
  Timer? countdownTimer; // Countdown timer
  bool _isRunning = true; //true일때 countdown

  //game time
  Timer? timer; // 타이머
  int seconds = 0; // 경과 초
  int time = 0; // 시행 횟수

  int test_set_time = 60; // 테스트 세트별 시간
  int test_total_time = 180; // 테스트 총 시간
  @override
  void initState() {
    super.initState();
    randIndex = getRandomIndex();

    // 3초 카운트, 3초 뒤 안보이게
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isVisible = false;
      });
    });

    // 3초 카운트다운 타이머
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          // 카운트다운이 끝나면 시작
          countdownTimer?.cancel(); // Cancel the countdown timer
          _isRunning = true;
          startTestTimer();
        }
      });
    });
  }

  void startTestTimer() {
    // 1초마다 타이머 콜백
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_isRunning) {
          seconds++; // 경과 시간(초) 갱신
          time += 1;
          countdownSeconds = 3;
          // isVisible = true;
          _isRunning = false;
          if (time == test_total_time) {
            time = 0;
            // 다음 페이지로 넘어가기
          }
        } else {
          if (countdownSeconds > 1) {
            countdownSeconds--;
          } else {
            // isVisible = false;
            _isRunning = true;
          }
        }
      });
    });
  }

  int getRandomIndex() {
    return Random().nextInt(words.length);
  }

  int getColorValue(String colorName) {
    switch (colorName) {
      case 'red':
        return 0xFFFF0000; // 빨강
      case 'blue':
        return 0xFF0000FF; // 파랑
      case 'yellow':
        return 0xFFffcb39; // 노랑
      case 'green':
        return 0xFF00FF00; // 초록
      case 'purple':
        return 0xFF800080; // 보라
      default:
        return 0xFF000000; // 검정
    }
  }

  void checkAnswer() {
    String userAnswer = answerController.text;
    String correctAnswer = words[randIndex][1];
    if (userAnswer == correctAnswer) {
      setState(() {
        correctCount++;
        randIndex = getRandomIndex();
        answerController.clear();
        isCorrected = true;
      });
    } else {
      setState(() {
        randIndex = getRandomIndex();
        answerController.clear();
        isCorrected = false;
      });
    }
  }

  void getNextQuestion() {
    setState(() {
      randIndex = getRandomIndex();
      answerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 862,
          height: 554,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(100, 25, 100, 230),
                // color: Colors.black,
                child: Center(
                  child: isVisible
                      ? null
                      : Text(
                          words[randIndex][0],
                          style: TextStyle(
                            fontSize: 200,
                            fontWeight: FontWeight.bold,
                            color: Color(getColorValue(words[randIndex][2])),
                          ),
                        ),
                ),
              ),
              Container(
                child: Center(
                  child: Container(
                    width: 401,
                    height: 134,
                    margin: EdgeInsets.fromLTRB(100, 320, 100, 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 155, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: answerController,
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                          onPressed: checkAnswer,
                          child: Text('확인'),
                        ),
                        Text(
                          '정답 수: $correctCount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                // left: (MediaQuery.of(context).size.width / 2) - (480 / 2),
                // top: (MediaQuery.of(context).size.height / 2) - (500 / 2),
                child: Visibility(
                    visible: isVisible,
                    child: Center(
                      child: CountdownTimer(seconds: 3),
                    )),
              ),
              if (isCorrected)
                Positioned(
                    // left: correctSignPosition.dx,
                    // top: correctSignPosition.dy,
                    child: Center(
                  child: correctSign(),
                )),
            ],
          ),
        ),
      ),
    );
  }
}
