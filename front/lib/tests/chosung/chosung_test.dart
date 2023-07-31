import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(chosungTest());
}

class chosungTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CenterPanel(),
    );
  }
}

class CenterPanel extends StatefulWidget {
  @override
  _CenterPanelState createState() => _CenterPanelState();
}

class _CenterPanelState extends State<CenterPanel> {
  String user_input = "";
  List<String> chosungs = ['ㄱ', 'ㅅ', 'ㅇ'];

  String _generateNextChosung() {
    Random random = Random();
    return chosungs[random.nextInt(chosungs.length)];
  }

  int test_set_time = 60; // 테스트 세트별 시간
  int test_total_time = 180; // 테스트 총 시간

  Timer? timer; // 타이머
  int seconds = 0; // 경과 초
  int time = 0; // 시행 횟수

  @override
  void initState() {
    super.initState();
    // 1초마다 타이머 콜백
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++; // 경과 시간(초) 갱신
        if (seconds % test_set_time == 0) {
          // n초 마다 초성 바꾸기
          time += 1;
          if (time == chosungs.length) {
            time = 0;
          }
          seconds -= test_set_time;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 화면이 제거될 때 타이머 해제
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 초성이 나오는 박스
            Container(
              width: 300,
              height: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(chosungs[time],
                    style: TextStyle(fontSize: 150),
                    textAlign: TextAlign.center),
              ),
            ),

            SizedBox(height: 50),

            // 사용자 입력 값 박스
            Container(
              width: 500,
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  user_input, // 사용자 입력 값
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 사용자 입력 대화상자 표시
          _showInputDialog(context);
        },
        child: Icon(Icons.edit),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endTop, // 버튼 위치 설정
      // 오른쪽 위에 타이머 시간 표시
      persistentFooterButtons: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Colors.grey[300],
          child: Text('${time + 1} 회차 / $seconds 초'),
        ),
      ],
    );
  }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("입력"),
          content: TextField(
            onChanged: (text) {
              setState(() {
                user_input = text; // 사용자 입력 값 갱신
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
