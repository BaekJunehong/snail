import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snail/tests/tests/chosung_test/chosung_test.dart';

class ChosungGuideScreen extends StatefulWidget {
  @override
  _ChosungGuideScreenState createState() => _ChosungGuideScreenState();
}

class _ChosungGuideScreenState extends State<ChosungGuideScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => chosungTest()),
      );
      Navigator.pop(context, result);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
