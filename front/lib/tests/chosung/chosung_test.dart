import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  String userInput = "";
  List<String> randomChosung = ['ㄱ', 'ㅅ', 'ㅇ'];

  String generateRandomChosung() {
    Random random = Random();
    return randomChosung[random.nextInt(randomChosung.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 초성이 나오는 판넬
            Container(
              width: 300,
              height: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(generateRandomChosung(),
                    style: TextStyle(fontSize: 150),
                    textAlign: TextAlign.center),
              ),
            ),

            SizedBox(height: 50),

            // 사용자 입력 값이 보이는 박스
            Container(
              width: 500,
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                userInput, // 사용자 입력 값
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
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
                userInput = text; // 사용자 입력 값 갱신
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
