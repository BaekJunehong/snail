import 'package:flutter/material.dart';
import 'package:snail/tests/guides/stroop_guide.dart';

class BeforeTestGuideScreen extends StatelessWidget {
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
                  crossAxisAlignment: CrossAxisAlignment.center, // 텍스트를 왼쪽으로 정렬
                  children: [
                    Center(
                      child: Center(
                        child: Text(
                          '꼭 확인해주세요!',
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      'assets/okay.png',
                      width: 300,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        '1. 원활한 게임 진행을 위해 기기는 가로로 사용해주세요!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        '2. 마이크와 카메라를 사용할 수 있도록 권한을 허용해주세요!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        '3. AI 얼굴 인식을 위해 밝고 잡음이 없는 환경에서 게임을 진행해주세요!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (StroopGuideScreen())));
                        },
                        child: Text(
                          '시작하기',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFffcb39),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          fixedSize: Size(165, 48),
                        )),
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
