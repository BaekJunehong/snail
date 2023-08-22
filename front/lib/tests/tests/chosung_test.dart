import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:snail/tests/correct_sign.dart';
import 'package:snail/tests/count_down.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart' as xml2json;
import 'package:snail/tests/eyetracking.dart';
import 'package:camera/camera.dart';

// UI는 완성, 채점 알고리즘 작성해야 함.
class chosungTest extends StatefulWidget {
  @override
  _chosungTestState createState() => _chosungTestState();
}

class _chosungTestState extends State<chosungTest> {
  int correctCount = 0;
  String userInput = "";
  List<String> chosungs = ['ㄱ', 'ㅅ', 'ㅇ'];
  int SearchNum = 0; //특정 단어로 검색한 갯수
  int test_set_time = 30; // 테스트 세트별 시간
  int test_total_time = 90; // 테스트 총 시간

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
  late CameraController _controller;
  late var imgSender;

  //고대 자모 -> 현대 자모
  String convertArchaicToModernJamo(String archaicJamo) {
    final Map<String, String> conversionMap = {
      'ᄀ': 'ㄱ',
      'ᄁ': 'ㄲ',
      'ᄂ': 'ㄴ',
      'ᄃ': 'ㄷ',
      'ᄄ': 'ㄸ',
      'ᄅ': 'ㄹ',
      'ᄆ': 'ㅁ',
      'ᄇ': 'ㅂ',
      'ᄈ': 'ㅃ',
      'ᄉ': 'ㅅ',
      'ᄊ': 'ㅆ',
      'ᄋ': 'ㅇ',
      'ᄌ': 'ㅈ',
      'ᄍ': 'ㅉ',
      'ᄎ': 'ㅊ',
      'ᄏ': 'ㅋ',
      'ᄐ': 'ㅌ',
      'ᄑ': 'ㅍ',
      'ᄒ': 'ㅎ'
    };

    return conversionMap[archaicJamo] ?? archaicJamo;
  }

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

  Future<void> openCamera() async {
    _controller = await initializeCamera();

    imgSender = FaceImgSender(_controller);
    imgSender.startSending();
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
              int etCount = imgSender.stopSending();
              Navigator.pop(context, [correctCount, etCount]);
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

  //검색의 결과가 나왔는가? -> 검색 결과 개수 초기화 함수
  Future<void> KoreanAPI(String userInput) async {
    var url = Uri.https(
        'server-snail.kro.kr:3443',
        '/KoreanAPI');

    try {
      var response = await http.post(url, body: {'word': userInput});
      if (response.statusCode == 200) {
        final xml2json.Xml2Json xml2Json = xml2json.Xml2Json();
        xml2Json.parse(response.body);
        var jsonData = xml2Json.toParker();

        var decodedData = jsonDecode(jsonData);
        var total = decodedData['channel']['total'];
        var totalAsInt = int.tryParse(total) ?? 0;
        print('Total: $totalAsInt');
        setState(() {
          SearchNum = totalAsInt;
        }); // 검색 결과 개수를 갱신
        print(SearchNum);
      } else {
        print('API 요청이 실패했습니다.');
      }
    } catch (e) {
      print('API 요청 중 오류 발생: $e');
    }
  }

  String extractConsonants(String text) {
    final List<int> unicodeValues = text.runes.toList();
    String consonants = '';

    for (int unicodeValue in unicodeValues) {
      if (0xAC00 <= unicodeValue && unicodeValue <= 0xD7A3) {
        // Check if it's a Hangul syllable
        final int consonantIndex = ((unicodeValue - 0xAC00) ~/ 28) ~/ 21;
        consonants += String.fromCharCode(0x1100 + consonantIndex);
      }
    }

    return consonants[0];
  }

  // user의 input 값을 받아 해당 단어가 존재하는지 검색
  // 있다면 개수가 0이 아닐 것.
  void checkAnswer(String userInput) async {
    await KoreanAPI(userInput); // 사전 api 필요

    print('$userInput API search number $SearchNum');

    String extractConsonant =
        extractConsonants(userInput).replaceAll(' ', '')[0].trim();
    extractConsonant = convertArchaicToModernJamo(extractConsonant);
    String cho = chosungs[order];

    print('초성$cho');
    print('초성$extractConsonant');
    print(extractConsonant == cho);
    if (SearchNum > 0 && extractConsonant == cho) {
      print(00);
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
            checkAnswer(userInput);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    // 화면이 제거될 때 타이머 해제
    _speech.cancel();
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
      body: Stack(
        children: [
          Image.asset(
            'assets/background/background_story.png', // 배경 이미지 파일 경로
            fit: BoxFit.fill,
            width: double.infinity, // 너비를 전체 화면으로 설정
            // height: double.infinity,
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  // color: Colors.white,
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
                        decoration:
                            BoxDecoration(color: Color.fromARGB(0, 0, 0, 0)),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  userInput, // 사용자 입력 값
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black),
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
                        left:
                            (MediaQuery.of(context).size.width / 2) - (380 / 2),
                        top: (MediaQuery.of(context).size.height / 2) -
                            (200 / 2),
                        child: correctSign(),
                      ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
