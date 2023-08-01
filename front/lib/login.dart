import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _id = ''; //입력된 아이디 저장
  String _pw = ''; //입력된 비밀번호 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              width: 565.0,
            ),
            SizedBox(height: 20),
            Container(
              width: 450, // 너비 설정
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _id = value; //입력된 아이디 업데이트
                  });
                },
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 450, // 너비 설정
              height: 48, // 높이 설정
              child: TextField(
                obscureText: true, //비밀번호를 '*'으로 표시
                onChanged: (value) {
                  setState(() {
                    _pw = value; //입력된 비밀번호 저장
                  });
                },
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  //로그인 시 함수 입력
                },
                child: Text(
                  '로그인',
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
    );
  }
}
