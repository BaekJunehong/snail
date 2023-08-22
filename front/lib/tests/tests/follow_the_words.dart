import 'package:flutter/material.dart';
import 'package:snail/tests/correct_sign.dart';
import 'package:snail/tests/count_down.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:snail/tests/eyetracking.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:math';
import 'dart:html' as html;

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
  List<String> UserInput = [];
  List<int> availableIndices = [];

  final _speech = stt.SpeechToText();
  late CameraController _controller;
  late var imgSender;

  var listenCount = 0;

  @override
  void initState() {
    super.initState();
    openCamera();

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
          _speech.initialize();
          getNextTest();
        }
      });
    });
  }

  Future<void> openCamera() async {
    _controller = await initializeCamera();

    imgSender = FaceImgSender(_controller);
    imgSender.startSending();
  }

  TextEditingController answerController = TextEditingController();
  List<bool> correct = [];
  int correctCount = 0;

  void checkAnswer(correctAnswer) {
    String userAnswer = user_input;

    print(userAnswer);
    print(correctAnswer);
    print(userAnswer == correctAnswer);
    //await Future.delayed(Duration(seconds: 1));
    user_input = '';
    if (userAnswer == correctAnswer) {
      setState(() {
        correct.add(true);
        correctCount++;
      });
    } else {
      setState(() {
        correct.add(false);
      });
    }
    getNextTest();
  }

  void getNextTest() async {
    await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});

    UserInput = [];
    listenCount = 0;
    if (numb >= 6) {
      int etCount = imgSender.stopSending();
      Navigator.pop(context, correctCount);
    }
    setState(() {
      if (numb != 0 && numb % 2 == 0) {
        wordNumber += 1;
      }
      numb += 1;

      Answer.clear(); // 기존 답변 인덱스 초기화

      //랜덤 글자 선정 . wordNumber 개수만큼
      while (Answer.length < wordNumber && availableIndices.isNotEmpty) {
        int randomIndex = Random().nextInt(availableIndices.length);
        int selectedWordIndex = availableIndices[randomIndex];
        Answer.add(words[selectedWordIndex]);

        // 이미 선택한 인덱스를 제거하여 중복 선택 방지
        availableIndices.removeAt(randomIndex);
      }
      print(Answer);
    });
    // await 음성 들려주기
    _listen();
  }

  void _listen() {
    if (!_speech.isListening) {
      _speech.listen(
        listenFor: Duration(seconds: 1000),
        pauseFor: Duration(seconds: 1000),
        cancelOnError: true,
        partialResults: true,
        listenMode: stt.ListenMode.dictation,
        onResult: (result) {
          print(result.recognizedWords);
          setState(() {
            _speech.stop();
            if (result.finalResult) {
              UserInput.add(result.recognizedWords);
              user_input = UserInput.join(' ');
              if (listenCount < wordNumber) {
                listenCount++;
                _listen();
              }
            }
          });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            // 높이 조정 가능한 크기로 설정
            // height: MediaQuery.of(context).size.height - 50, // 예시로 50을 빼서 조정
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/background_voca_rp.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Stack(
            children: [
              Positioned(
                  // left: (MediaQuery.of(context).size.width / 2) - (500 / 2),
                  // top: (MediaQuery.of(context).size.height / 2) - (520 / 2),
                  child: Center(
                child: Container(

                  height: 600,

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
                        width: 480,

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
                      const SizedBox(height: 50),
                      // 확인 버튼
                      ElevatedButton(
                        onPressed: (user_input == '')
                            ? null
                            : () {
                                // 체크 로직
                                checkAnswer(Answer.join(' '));
                              },
                        child: Text(
                          '확인',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: (user_input == '')
                              ? Color(0xFFd9d9d9)
                              : Color(0xFFffcb39),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          fixedSize: Size(165, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
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
        ],
      ),
    );
  }
}
