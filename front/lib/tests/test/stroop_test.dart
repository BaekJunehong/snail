import 'package:flutter/material.dart';
import 'dart:math';
import 'package:snail/tests/correct_sign.dart';

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

  int randIndex = 0;
  TextEditingController answerController = TextEditingController();
  int correctCount = 0;

  @override
  void initState() {
    super.initState();
    randIndex = getRandomIndex();
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
      });
    } else {
      setState(() {
        randIndex = getRandomIndex();
        answerController.clear();
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
                child: Center(
                  child: Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
