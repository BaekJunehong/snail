import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

// 서비스에서 출제하는 문제
class bubbleFromService extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: BubbleSpecialThree(
          text: '첫 번째 문제는...',
          color: Color(0xFFd9d9d9),
          tail: true,
          textStyle: TextStyle(color: Colors.black, fontSize: 16),
          isSender: false //말풍선 방향
          ),
    );
  }
}

// 아이가 입력한 음성(메시지)
// 텍스트 부분에 STT 들어가면 될 것 같음.
class bubbleFromChild extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: BubbleSpecialThree(
        text: '정답을 말해주세요!',
        color: Color(0xFFFFCB39),
        tail: true,
        textStyle: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
