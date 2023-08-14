import 'package:flutter/material.dart';
import 'package:snail/tests/correct_sign.dart';
import 'package:snail/tests/count_down.dart';
import 'dart:async';
import 'dart:math';

class followTest extends StatefulWidget {
  @override
  _followeTestState createState() => _followeTestState();
}

//논의 사항 : 테스트별 시간

class _followeTestState extends State<followTest> {
  String user_input = "";
  List<String> words = [
    '자라',
    '모자',
    '거미',
    '미로',
    '기차',
    '사자',
    '개미',
    '나비',
    '오이',
    '시계',
    '고기',
    '머리',
    '누나',
    '카드',
    '바지',
    '나무',
    '오리',
    '과자'
  ];
  int test_set_time = 10; // 테스트 세트별 시간

  Timer? timer; // 타이머
  int seconds = 0; // 경과 초
  int time = 0; // 시행 횟수
  int wordNumber = 2; //단어 개수
  int numb = 0; // 단어 개수 별 시행 횟수

  // int countdownTime = 3;
  int countdownSeconds = 3; // Countdown seconds
  Timer? countdownTimer; // Countdown timer

  bool isCorrected = false;
  bool isVisible = true;
  // bool _isRunning = false;

  List<String> Answer = [];
  List<int> availableIndices = [];

  @override
  void initState() {
    super.initState();

    // 3초 카운트, 3초 뒤 안보이게
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isVisible = false;
      });
    });

    availableIndices = List.generate(words.length, (index) => index);

    // 3초 카운트다운 타이머
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          // 카운트다운이 끝나면 시작
          countdownTimer?.cancel(); // Cancel the countdown timer
          while (Answer.length < wordNumber) {
            int randomIndex = Random().nextInt(words.length);
            if (!Answer.contains(randomIndex)) {
              Answer.add(words[randomIndex]);
              availableIndices.removeAt(randomIndex);
            }
          }
          startTestTimer();
        }
      });
    });
  }

  TextEditingController answerController = TextEditingController();
  List<bool> correct = [];
  int correctCount = 0;
  void checkAnswer(correctAnswer) {
    String userAnswer = answerController.text;
    if (userAnswer == correctAnswer) {
      setState(() {
        correct.add(true);
        correctCount++;
        answerController.clear();
      });
    } else {
      setState(() {
        correct.add(false);
        answerController.clear();
      });
    }
  }

  void startTestTimer() {
    // 1초마다 타이머 콜백
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (wordNumber < 5) {
          seconds++; // 경과 시간(초) 갱신
          if (seconds % test_set_time == 0) {
            // n초 마다 글자 바꾸기
            time += 1;
            if (numb == 1) {
              numb = 0;
              wordNumber += 1;
            } else {
              numb += 1;
            }

            Answer.clear(); // 기존 답변 인덱스 초기화

            //랜덤 글자 선정 . wordNumber 개수만큼
            while (Answer.length < wordNumber && availableIndices.isNotEmpty) {
              int randomIndex = Random().nextInt(availableIndices.length);
              int selectedWordIndex = availableIndices[randomIndex];
              Answer.add(words[selectedWordIndex]);

              // 이미 선택한 인덱스를 제거하여 중복 선택 방지
              availableIndices.removeAt(randomIndex);
            }
          }

          print(Answer);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 화면이 제거될 때 타이머 해제
    timer?.cancel();
    countdownTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        // 전체 화면
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(side: BorderSide(width: 0.50)),
          ),
          child: Stack(
            children: [
              Positioned(
                  // left: (MediaQuery.of(context).size.width / 2) - (500 / 2),
                  // top: (MediaQuery.of(context).size.height / 2) - (520 / 2),
                  child: Center(
                child: Container(
                  height: 520,
                  padding: const EdgeInsets.all(10),
                  //clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Color.fromARGB(0, 0, 0, 0)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 초성
                      Container(
                        width: 800,
                        height: 300,
                        padding: EdgeInsets.all(20),
                        // margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Center(
                          child: isVisible
                              ? null
                              : Text(
                                  '들려준 단어를 따라 말해보세요!',
                                  style: TextStyle(
                                    fontSize: 50,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 50),
                      // 입력칸
                      Container(
                        width: 240,
                        height: 100,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            user_input, // 사용자 입력 값
                            style: TextStyle(fontSize: 30, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  // 검사 프레임

                  ),
              // 3초 카운트 다운
              Positioned(
                left: (MediaQuery.of(context).size.width / 2) - (480 / 2),
                top: (MediaQuery.of(context).size.height / 2) - (500 / 2),
                child: Visibility(
                  visible: isVisible,
                  child: CountdownTimer(seconds: 3),
                ),
              ),
              // correct
              if (isCorrected)
                Positioned(
                  left: (MediaQuery.of(context).size.width / 2) - (380 / 2),
                  top: (MediaQuery.of(context).size.height / 2) - (200 / 2),
                  child: correctSign(),
                ),
            ],
          ),
        ),
      ],
    ));
  }
}
