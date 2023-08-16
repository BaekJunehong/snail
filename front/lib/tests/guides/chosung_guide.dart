import 'package:flutter/material.dart';

//import 'package:flutter_svg/flutter_svg.dart';
import 'package:snail/tests/tests/chosung_test_demo.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(body: ChosungGuideScreen())));
}

class ChosungGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 20), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => chosungTest(),
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
                      '단어 유창성',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '소요 시간: 03분',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '화면에서 보여주는 자음으로 시작하는 단어를 최대한 많이 말해주세요!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      'assets/chosung.png',
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
