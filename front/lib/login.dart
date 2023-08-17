import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'signup.dart';

import 'package:snail/profileselect.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _id = ''; //입력된 아이디 저장
  String _pw = ''; //입력된 비밀번호 저장

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  bool isAlphanumeric(String input) {
    final alphanumericRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegExp.hasMatch(input);
  }

  //비밀번호와 비밀번호 확인란의 텍스트가 일치하는지 확인

  //비밀번호 불일치하면 스낵바 띄움
  void _showLoginErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('아이디,비밀번호를 확인해주세요.')),
    );
  }

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
                controller: idController,
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
                controller: pwController,
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
                onPressed: () async {
                  //로그인 시 함수 입력
                  var url = Uri.http(
                      'ec2-43-202-125-41.ap-northeast-2.compute.amazonaws.com:3000',
                      '/login');
                  var response = await http
                      .post(url, body: {'USER_ID': _id, 'USER_PW': _pw});

                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body);

                    if (data == 1) {
                      final storage = const FlutterSecureStorage();
                      await storage.write(key: 'USER_ID', value: _id);

                      idController.clear();
                      pwController.clear();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  (ProfileSelectionScreen())));
                    } else {
                      // 아이디, 패스워드 에러
                      _showLoginErrorSnackBar();
                    }
                  }
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
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                //텍스트 클릭 시 signup.dart의 SignupScreen으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text(
                'SNaiL이 처음이신가요? | 회원가입',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
