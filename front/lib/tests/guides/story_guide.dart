import 'package:flutter/material.dart';
import 'package:snail/tests/guides/backspace_guide.dart';
import 'package:snail/tests/test/story_test.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final GlobalKey<NavigatorState> navigatorKey;
  MyNavigatorObserver(this.navigatorKey);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute == null) {
      //뒤로 가기 동작
      print("뒤로 가기 동작 감지: BackSpaceGuideScreen을 push합니다.");
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => BackSpaceGuideScreen(),
        fullscreenDialog: true,
      ));
    }
  }
}

class StoryGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => StoryTest(),
      ));
    });

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
                      '이야기 이해하기',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '소요 시간: 10분',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '이야기 영상을 보고, 문제에 대한 답을 말해주세요!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      'assets/story.png',
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
