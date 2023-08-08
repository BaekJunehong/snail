import 'package:flutter/material.dart';
import 'package:snail/addprofile.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

class ProfileCard extends StatelessWidget {
  final bool hasChild = false;

  //ProfileCard({this.hasChild});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        if (hasChild) {
          // 캐릭터가 있을 경우 starttest.dart 페이지로 이동
          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartTestScreen()),
          );
          */
        } else {
          // 캐릭터가 없을 경우 addprofile.dart 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChildInfoInputScreen()),
          );
        }
      },
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        side: BorderSide.none,
      ),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Color(0xFFd9d9d9),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: hasChild
              ? Image.asset('assets/character.png') // 캐릭터가 있을 경우 다른 이미지 표시
              : Icon(Icons.add, size: 40, color: Colors.white),
        ),
      ),
    );
  }
}
