import 'package:flutter/material.dart';
import 'package:snail/starttest.dart';
import 'package:snail/tests/guides/before_test_guide.dart';

class NoResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/xcomment.png'),
            Text(
              '올해 진행된 검사 내역이 없어요.',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              '게임을 한 다음 결과를 확인해볼까요?',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (BeforeTestGuideScreen())));
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
                  ),
                ),
                SizedBox(width: 70),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (StartTestScreen())));
                  },
                  child: Text('돌아가기',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFd9d9d9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    fixedSize: Size(165, 48),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
