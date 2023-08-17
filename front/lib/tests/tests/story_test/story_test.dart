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

  @override
  void initState() {
    super.initState();
    _showBubbles();
  }

  void _showBubbles() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        showGreetBubble = true;
      });
    });

    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        showQuestionBubble = true;
      });
    });

    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        showAnswerBubble = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingResultScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '종료하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFffcb39),
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
