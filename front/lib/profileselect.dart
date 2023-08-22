import 'package:flutter/material.dart';
import 'package:snail/addprofile.dart';
import 'package:snail/starttest.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

final storage = const FlutterSecureStorage();

class ProfileSelectionScreen extends StatefulWidget {
  @override
  _ProfileSelectionScreenState createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  List<Map<String, dynamic>>? child_info;

  Future<List<Map<String, dynamic>>> _fetchChildData() async {
    final parent_id = await storage.read(key: 'USER_ID');
    final url = Uri.https(
        'server-snail.kro.kr:3443',
        '/fetchChildData');
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
        'IMG': data[i]['IMG'],
      });
    }
    return rows;
  }

  // 화면 갱신
  void refreshData() {
    setState(() {
      _fetchChildData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchChildData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          child_info = snapshot.data;
          // 아이 선택 위젯
          final profileCards = <Widget>[];
          if (child_info != null) {
            for (int i = 0; i < 3; i++) {
              if (i < child_info!.length) {
                profileCards.add(ProfileCard(
                    child_info: child_info![i], onRefresh: refreshData));
              } else {
                profileCards
                    .add(ProfileCard(child_info: null, onRefresh: refreshData));
              }
            }
          } else {
            for (int i = 0; i < 3; i++) {
              profileCards
                  .add(ProfileCard(child_info: null, onRefresh: refreshData));
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
                    onPressed: () async {
                      await storage.delete(key: 'USER_ID');
                      Navigator.pop(context);
                    },
                    child: Text(
                      '로그아웃',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey, // 버튼의 배경색 // 버튼의 글꼴 크기
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      fixedSize: Size(165, 48),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class ProfileCard extends StatefulWidget {
  final Map<String, dynamic>? child_info;
  final VoidCallback? onRefresh;

  ProfileCard({this.child_info, this.onRefresh});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String child_name = '';

  @override
  void initState() {
    super.initState();
    if (widget.child_info != null) {
      child_name = widget.child_info!['NAME'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        if (widget.child_info != null) {
          // 캐릭터가 있을 경우 starttest.dart 페이지로 이동
          await storage.write(key: 'CHILD_ID', value: widget.child_info!['CHILD_ID']);
          await storage.write(key: 'CHILD_NAME', value: widget.child_info!['NAME']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartTestScreen()),
          );
        } else {
          // 캐릭터가 없을 경우 addprofile.dart 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChildInfoInputScreen()),
          ).then((value) {
            if (widget.onRefresh != null) widget.onRefresh!();
          });
        }
      },
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        side: BorderSide.none,
      ),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFFd9d9d9),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: (widget.child_info != null)
                  ? Image.asset('assets/profile.png') // 캐릭터가 있을 경우 다른 이미지 표시
                  : Icon(Icons.add, size: 40, color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          //자녀 이름 입력하기!
          Text(
            child_name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
