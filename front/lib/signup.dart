import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

//DB에 중복되는 아이디 판단하는 것은 DB 개발 후 진행해주세요!

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {  
  String _id = ''; //입력된 아이디 저장
  String _pw = ''; //입력된 비밀번호 저장
  String _pwConfirm = ''; //비밀번호 확인란 내용 저장

  //영어와 숫자만 입력 가능하도록 함.
  bool isAlphanumeric(String input) {
    final alphanumericRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegExp.hasMatch(input);
  }

  //비밀번호와 비밀번호 확인란의 텍스트가 일치하는지 확인
  bool isPasswordMatch() {
    return _pw == _pwConfirm;
  }

  //비밀번호 불일치하면 스낵바 띄움
  void _showPasswordMismatchSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('비밀번호를 확인해주세요.')),
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
            SizedBox(height: 10),
            Container(
              width: 450, // 너비 설정
              height: 48, // 높이 설정
              child: TextField(
                obscureText: true, //비밀번호를 '*'으로 표시
                onChanged: (value) {
                  setState(() {
                    _pwConfirm = value; //입력된 비밀번호 저장
                  });
                },
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (!isAlphanumeric(_id)) {
                    SnackBar(content: Text('ID는 영어와 숫자의 조합으로 작성해주세요!'));
                  } else if (!isPasswordMatch()) {
                    _showPasswordMismatchSnackBar();
                  } else {
                    print('아이디 중복?');
                    // 아이디 중복 확인
                    var url = Uri.http('ec2-43-202-128-142.ap-northeast-2.compute.amazonaws.com:3000', '/checkDuplicatedID', {'USER_ID': _id});
                    print(url);
                    var response = await http.get(url);
                    print('Response status: ${response.statusCode}');

                    var data = jsonDecode(response.body);
                    var exist = data['exist'];
                    
                    // 중복이 아닌경우 정보 저장
                    if (exist != 1){
                      print('아이디 중복 아니래');
                      var url = Uri.http('ec2-43-202-128-142.ap-northeast-2.compute.amazonaws.com:3000', '/saveUserInfo');
                      var response = await http.post(url, body: {'USER_ID': _id, 'USER_PW': _pw});
                      print('Response status: ${response.statusCode}');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  }
                },
                child: Text(
                  '회원가입',
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
