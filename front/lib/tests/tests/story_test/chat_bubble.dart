import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

//인사 및 안내 버블. 가장 첫 번째에 나오게 하기
class GreetBubbleFromService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10), // 여백 설정
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 5, top: 30),
              child: Image.asset('assets/profile.png', width: 100),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BubbleSpecialThree(
                  text: '안녕! 이야기는 재미있었어요?',
                  color: Color(0xFFd9d9d9),
                  tail: false,
                  textStyle: TextStyle(color: Colors.black, fontSize: 16),
                  isSender: false,
                ),
                BubbleSpecialThree(
                  text: '지금부터 이야기와 관련된 문제를 잘 보고 정답을 말해주세요!',
                  color: Color(0xFFd9d9d9),
                  tail: true,
                  textStyle: TextStyle(color: Colors.black, fontSize: 16),
                  isSender: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//문제 출제 버블
class QuestionBubbleFromService extends StatelessWidget {
  final String text;
  QuestionBubbleFromService({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 5, top: 30),
            child: Image.asset('assets/profile.png', width: 100),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: BubbleSpecialThree(
              text: text,
              color: Color(0xFFd9d9d9),
              tail: true, // 꼬리 없는 말풍선
              textStyle: TextStyle(color: Colors.black, fontSize: 16),
              isSender: false,
            ),
          ),
        ],
      ),
    );
  }
}

//아이의 답변
class BubbleFromChildBefore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: BubbleSpecialThree(
        text: '정답을 말해주세요!',
        color: Color(0xFFFFCB39),
        tail: true, // 꼬리 없는 말풍선
        textStyle: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}

class BubbleFromChildAfter extends StatelessWidget {
  final String Answer;
  BubbleFromChildAfter({required this.Answer});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: BubbleSpecialThree(
        text: Answer,
        color: Color(0xFFFFCB39),
        tail: true, // 꼬리 없는 말풍선
        textStyle: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}

// 검사 끝. 가장 마지막에 나옴
// DB에 검사 결과 저장과 함께 종료 버튼 활성화
class EndBubbleFromService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10), // 여백 설정
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 5, top: 0),
              child: Image.asset('assets/profile.png', width: 100),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BubbleSpecialThree(
                  text: '정말 잘했어요! 이제 모든 게임이 끝났어요.',
                  color: Color(0xFFd9d9d9),
                  tail: false,
                  textStyle: TextStyle(color: Colors.black, fontSize: 16),
                  isSender: false,
                ),
                BubbleSpecialThree(
                  text: '종료하기 버튼을 누르면 게임을 마무리할 수 있어요!',
                  color: Color(0xFFd9d9d9),
                  tail: true,
                  textStyle: TextStyle(color: Colors.black, fontSize: 16),
                  isSender: false,
                ),
                BubbleSpecialThree(
                  text: '우리 또 만나요! 안녕~!',
                  color: Color(0xFFd9d9d9),
                  tail: true,
                  textStyle: TextStyle(color: Colors.black, fontSize: 16),
                  isSender: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
