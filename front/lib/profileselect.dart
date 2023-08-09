import 'package:flutter/material.dart';
import 'package:snail/addprofile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileSelectionScreen extends StatelessWidget {
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>>? child_info;

  Future<List<Map<String, dynamic>>> _fetchChildData() async {
    final parent_id = await storage.read(key: 'USER_ID');

    final url = Uri.http('ec2-43-202-128-142.ap-northeast-2.compute.amazonaws.com:3000', '/fetchChildData');
    final response = await http.post(url, body: {'USER_ID': parent_id});

    // parent_id가 가진 child 정보
    var data = jsonDecode(response.body);
    final rows = <Map<String, dynamic>>[];
    for (int i = 0; i < data.length; i++) {
      rows.add({
        'PARENT_ID': data[i]['PARENT_ID'],
        'CHILD_ID': data[i]['CHILD_ID'],
        'NAME': data[i]['NAME'],
        'SEX': data[i]['SEX'],
        'BIRTH': data[i]['BIRTH'],
      });
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchChildData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          child_info = snapshot.data;
          print(child_info);
          // 아이 선택 위젯
          final profileCards = <Widget>[];
          if (child_info != null) {
            for (int i = 0; i < 3; i++) {
              print(child_info!.length);
              if (i < child_info!.length) {
                profileCards.add(ProfileCard(child_info: child_info![i]));
              } else {
                profileCards.add(ProfileCard(child_info: null));
              }
            }
          } else {
            print('아이없음');
            for (int i = 0; i < 3; i++) {
              profileCards.add(ProfileCard(child_info: null));
            }
          }
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
                    children: profileCards,
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
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  Map<String, dynamic>? child_info;

  ProfileCard({this.child_info});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        if (child_info != null) {
          print(child_info);
          print('아이있음');
          // 캐릭터가 있을 경우 starttest.dart 페이지로 이동
          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartTestScreen()),
          );
          */
        } else {
          print('아이없음');
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
          child: (child_info != null)
              ? Image.asset('assets/correct.png') // 캐릭터가 있을 경우 다른 이미지 표시
              : Icon(Icons.add, size: 40, color: Colors.white),
        ),
      ),
    );
  }
}
