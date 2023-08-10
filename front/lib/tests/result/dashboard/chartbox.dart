import 'package:flutter/material.dart';

//차트 컨테이너
class ChartBox extends StatelessWidget {
  final String title;
  final String description;

  // 아이 & 평균 연령대 데이터
  final double dataValue;
  final double avgDataValue;

  //전체 비교 막대
  final double maxWidth = 100;

  ChartBox({
    required this.title,
    required this.description,
    required this.dataValue,
    required this.avgDataValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1300,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0XFFd9d9d9), width: 2.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Divider(
              color: Color(0XFFd9d9d9),
              thickness: 2,
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 30),
            // Custom Vertical Bar Chart with Aligned Start
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align bars to the start
              children: [
                Container(
                  width: dataValue * 1000,
                  height: 30,
                  color: Color(0XFFffcb39),
                ),
                SizedBox(height: 20), // Gap between bars
                Container(
                  width: avgDataValue * 1000,
                  height: 30,
                  color: Color(0XFFc4c4c4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
