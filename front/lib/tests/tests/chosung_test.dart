import 'package:flutter/material.dart';
import 'package:snail/tests/correct_sign.dart';
import 'package:snail/tests/count_down.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:html' as html;

// UI는 완성, 채점 알고리즘 작성해야 함.
class chosungTest extends StatefulWidget {
  @override
  _chosungTestState createState() => _chosungTestState();
}

class _chosungTestState extends State<chosungTest> {
  int correctCount = 0;
  String userInput = "";
  List<String> chosungs = ['ㄱ', 'ㅅ', 'ㅇ'];

  int test_set_time = 20; // 테스트 세트별 시간
  int test_total_time = 180; // 테스트 총 시간

  Timer? timer; // 타이머
  int seconds = 0; // 경과 초
  int order = 0; // 시행 횟수

  // int countdownTime = 3;
  int countdownSeconds = 3; // Countdown seconds
  Timer? countdownTimer; // Countdown timer

  bool isCorrected = false;
  bool isVisible = true;
  bool _isRunning = false;

  final _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();

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
          _speech.initialize();
          getAudio();
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
          if (seconds % test_set_time == 0) {
            // n초 마다 초성 바꾸기
            order += 1;
            countdownSeconds = 3;
            isVisible = true;
            _isRunning = false;
            if (order == chosungs.length) {
              order = 0;
              // 다음 페이지로 넘어가기
            }
            getAudio();
          }
        } else {
          if (countdownSeconds > 1) {
            countdownSeconds--;
          } else {
            isVisible = false;
            _isRunning = true;
          }
        }
      });
    });
  }

  void checkAnswer() async {
    String userAnswer = userInput;
    //chosungs[order] 에 맞는 답
    String correctAnswer = '';  // 사전 api 필요
    //if (userAnswer == correctAnswer) {
    if (true) {
      setState(() {
        isCorrected = true;

        correctCount++;
      });
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        isCorrected = false;
        userInput = '';
      });
    } else {
      setState(() {
        isCorrected = false;
        // 틀린거로 바꾸면 ㄱㅊ
      });
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        userInput = '';
      });
    }
      getAudio();
  }

  void getAudio() async {
    await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
    if (!_speech.isListening) {
      _speech.listen(
        listenFor: Duration(seconds: 1000),
        pauseFor: Duration(seconds: 1000),
        cancelOnError: true,
        partialResults: true,
        listenMode: stt.ListenMode.dictation,
        onResult: (result) async {
          _speech.stop();
          userInput = result.recognizedWords;
          if (result.finalResult) {
            checkAnswer();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    // 화면이 제거될 때 타이머 해제
    timer?.cancel();
    countdownTimer?.cancel();
  }

  void start() {
    _isRunning = true;
  }

  void pause() {
    _isRunning = false;
  }
  //iscorrected = true 조건

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
                left: (MediaQuery.of(context).size.width / 2) - (500 / 2),
                top: (MediaQuery.of(context).size.height / 2) - (520 / 2),
                // 검사 프레임
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
                        width: 500,
                        height: 300,
                        padding: EdgeInsets.all(20),
                        // decoration: BoxDecoration(
                        //   color: Colors.grey[200],
                        //   borderRadius: BorderRadius.circular(50),
                        // ),
                        child: Center(
                          child: isVisible
                              ? null
                              : Text(
                                  chosungs[order],
                                  style: TextStyle(
                                      fontSize: 150, color: Colors.black),
                                  textAlign: TextAlign.center,
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
                            userInput, // 사용자 입력 값
                            style: TextStyle(fontSize: 30, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
