import 'package:flutter/material.dart';
import 'package:snail/tests/result/loadingresult.dart';
import 'package:snail/tests/tests/story_test/chat_bubble.dart';

class StoryTestScreen extends StatefulWidget {
  @override
  _StoryTestScreenState createState() => _StoryTestScreenState();
}

class _StoryTestScreenState extends State<StoryTestScreen> {
  bool showGreetBubble = false;
  bool showQuestionBubble = false;
  bool showAnswerBubble = false;
  bool showEndBubble = false;

  @override
  void initState() {
    super.initState();
    _showBubbles();
  }

  void _showBubbles() async {
    await Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        showGreetBubble = true;
      });
    });

    await Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        showQuestionBubble = true;
      });
    });

    await Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        showAnswerBubble = true;
      });
    });

    await Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        showEndBubble = true;
      });
    });
  }

  // void _onAnswerBubbleSubmitted() {
  //   setState(() {
  //     answeredBubbleCount++; //응답한 말풍선 개수 더함
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = showEndBubble; // showEndBubble에 따라 버튼 활성화

    return Scaffold(
      body: Stack(
        children: [
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
                  AnimatedContainer(
                    duration: Duration(milliseconds: 30000),
                    curve: Curves.easeInOut,
                    height: showQuestionBubble ? null : 0,
                    child: QuestionBubbleFromService(),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 30000),
                    curve: Curves.easeInOut,
                    height: showAnswerBubble ? null : 0,
                    child: BubbleFromChild(),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 30000),
                    curve: Curves.easeInOut,
                    height: showAnswerBubble ? null : 0,
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
