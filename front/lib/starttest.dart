import 'package:flutter/material.dart';
import 'package:snail/tests/guides/before_test_guide.dart';
import 'package:snail/tests/result/parentnote.dart';

class StartTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              // 아이 이름, 개월 수는 DB에서 꺼내 써야 함.
              'OO이를 만난 지 N개월이 지났어요!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 25),
            Image.asset(
              './assets/profile.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                // 검사 전 가이드로 이동. 아이 데이터 갖고 가야 함.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeforeTestGuideScreen(),
                  ),
                );
              },
              child: Text(
                '시작하기',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFffcb39),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                fixedSize: Size(165, 48),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 검사 전 가이드로 이동. 아이 데이터 갖고 가야 함.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParentNoteScreen(),
                  ),
                );
              },
              child: Text(
                '부모노트',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFd9d9d9),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                fixedSize: Size(165, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
