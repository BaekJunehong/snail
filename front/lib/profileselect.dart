import 'package:flutter/material.dart';

class ProfileSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '프로필을 선택해주세요',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileCard(),
                ProfileCard(),
                ProfileCard(),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                print('버튼이 눌렸습니다!');
              },
              child: Text(
                '부모노트',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFffcb39), // 버튼의 배경색 // 버튼의 글꼴 크기
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

//프로필 카드에 자녀 데이터가 있으면 starttest.dart 페이지로
//프로필 카드에 자녀 데이터가 없으면 addprofile.dart 페이지로
class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFFd9d9d9),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Icon(Icons.add, size: 40, color: Colors.white),
      ),
    );
  }
}
