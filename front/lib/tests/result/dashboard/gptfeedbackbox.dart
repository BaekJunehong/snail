import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snail/profileselect.dart';
import 'package:http/http.dart' as http;

class GPTFeedbackBox extends StatelessWidget {
  final double grayBoxWidth = 765;
  final double grayBoxHeight = 400;
  final double paddingValue = 60;

  @override
  Widget build(BuildContext context) {
    //날짜 가져오기
    //DB에서 검사 일자를 가져오도록 함.
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy.MM.dd').format(now);

    return Container(
      width: grayBoxWidth,
      height: grayBoxHeight,
      decoration: BoxDecoration(
        color: Color(0XFFd9d9d9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '달 선생님의 피드백',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 25),
            Divider(
              color: Color(0XFF777777),
              thickness: 2,
            ),
            SizedBox(height: 25),
            //이곳에 gpt 피드백이 들어갈 거!
            //텍스트가 길어지면 이 영역만 스크롤 가능하도록
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // GPT 피드백. 길어질 수 있으므로 스크롤 가능하도록 설정했음.
                    Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text...',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
