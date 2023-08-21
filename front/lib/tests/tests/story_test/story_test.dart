import 'package:flutter/material.dart';
import 'package:snail/tests/result/loadingresult.dart';
import 'package:snail/tests/tests/story_test/chat_bubble.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:html' as html;

class StoryTestScreen extends StatefulWidget {
  final int videoNum; // 실행된 비디오 index
  StoryTestScreen({required this.videoNum});
  @override
  _StoryTestScreenState createState() => _StoryTestScreenState();
}

class _StoryTestScreenState extends State<StoryTestScreen> {
  bool showGreetBubble = false;
  bool showQuestionBubble = false;
  bool showAnswerBubble = false;
  bool showEndBubble = false;
  int answeredBubbleCount = 0;
  String userInput = '';
  final _speech = stt.SpeechToText();

  //정답처리 관련 변수
  bool isCorrected = false;
  int correctCount = 0;

  //1. 우리끼리 가자 2. 내 꿈은 무슨 색일까
  List<List> Question = [
    [
      '지금 동물 마을의 계절은 무엇인가요?',
      '겨울잠을 잔다고 말하면서 나무 구멍으로 들어간 동물 친구는 누구였나요?',
      '맛있는 물고기를 잡으로 물에 뛰어든 동물 친구는 누구였나요?',
      '아기 토끼가 여우가 쫒아온다고 소리치자 산양 할아버지는 어떻게 여우를 쫓아 냈나요?',
      '아기 토끼가 산양 할아버지를 찾아 간 이유는 무엇인가요?'
    ],
    [
      '위험에 빠진 사람들을 구해주는 소방관이 되는 꿈은 무슨 색인가요?',
      '아이들에게 이것 저것 알려주는 선생님이 되는 꿈은 무슨 색인가요?',
      '할머니가 가져오신 신비로운 함에는 무엇이 들어있었나요?',
      '꿈의 색을 이것저것 섞어보던 아름이는 왜 울었을까?',
      '할머니께서는 오색 색동옷을 입으면 옷을 입은 사람에게 무슨 일이 일어난다고 하셨나요?'
    ]
  ];
  List<String> Answer = [''];

  @override
  void initState() {
    super.initState();
    _showBubblesStart();
    _speech.initialize();
    startQuestionSequence();
  }

  void startQuestionSequence() {
    if (answeredBubbleCount < Question[widget.videoNum].length) {
      _showBubbleQuestion();
      print(answeredBubbleCount);
      _onAnswerBubbleSubmitted();
      print(answeredBubbleCount);
    } else {
      _showBubbleLast();
    }
  }

  void _showBubblesStart() async {
    await Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        showGreetBubble = true;
      });
    });
  }

  //문제 생성
  void _showBubbleQuestion() async {
    await Future.delayed(Duration(milliseconds: 2000), () {
      print('QuestionBubble = $answeredBubbleCount');
      setState(() {
        showQuestionBubble = true;
      });
    });
    await Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        print('AnswerBubble = $Answer');
        print(showEndBubble);
        showAnswerBubble = true; // 응답 말풍선을 표시
      });
    });
    getNextQuestion();
  }

  Widget _questionAndAnswer(int questionIndex) {
    return Container(
      child: Column(children: [
        AnimatedContainer(
          duration: Duration(seconds: 30),
          curve: Curves.easeInOut,
          height: showQuestionBubble ? null : 0,
          child: QuestionBubbleFromService(
              text: Question[widget.videoNum][questionIndex]),
        ),
        AnimatedContainer(
          duration: Duration(seconds: 30),
          curve: Curves.easeInOut,
          height: showAnswerBubble ? null : 0,
          child: questionIndex >= Answer.length - 1
              ? BubbleFromChildBefore()
              : BubbleFromChildAfter(Answer: Answer[questionIndex + 1]),
        ),
      ]),
    );
  }

  void getNextQuestion() async {
    print('getNextQuestion $answeredBubbleCount');
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
            Answer.add(userInput);
            // _showBubbleQuestion();
            startQuestionSequence();
          }
        },
      );
    }
  }

  void _showBubbleLast() {
    print('showBubbleLast = $answeredBubbleCount');
    print('showEndBubble = $showEndBubble');
    setState(() {
      showEndBubble = true;
    });
  }

  void _onAnswerBubbleSubmitted() {
    setState(() {
      answeredBubbleCount += 1; //응답한 말풍선 개수 더함
    });
  }

  @override
  void dispose() {
    _speech.stop(); // Stop the speech recognition
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = showEndBubble; // showEndBubble에 따라 버튼 활성화

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_story.png'), // 이미지 경로 지정
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(60),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 30000),
                    curve: Curves.easeInOut,
                    height: showGreetBubble ? null : 0,
                    child: GreetBubbleFromService(),
                  ),
                  if (answeredBubbleCount >= 1) _questionAndAnswer(0),
                  if (answeredBubbleCount >= 2) _questionAndAnswer(1),
                  if (answeredBubbleCount >= 3) _questionAndAnswer(2),
                  if (answeredBubbleCount >= 4) _questionAndAnswer(3),
                  if (answeredBubbleCount >= 5) _questionAndAnswer(4),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 30000),
                    curve: Curves.easeInOut,
                    height: showEndBubble ? null : 0,
                    child: EndBubbleFromService(),
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoadingResultScreen(),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      '종료하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: isButtonEnabled
                          ? Color(0xFFffcb39)
                          : Color(0xFFd9d9d9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      fixedSize: Size(165, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
