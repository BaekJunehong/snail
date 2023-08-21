import 'package:flutter/material.dart';

//차트 컨테이너
class ChartBox extends StatelessWidget {
  final String title;
  final String description;

  // 아이 & 평균 연령대 데이터
  final double dataValue;
  final double avgDataValue;

  // //전체 비교 막대
  // final double maxWidth = 1300;

  ChartBox({
    required this.title,
    required this.description,
    required this.dataValue,
    required this.avgDataValue,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth < 800;
    final double maxWidth = isSmallScreen ? screenWidth * 0.9 : 1300;
    double containerHeight = 280; //기본값

    if (isSmallScreen) {
      // isSmallScreen일 때, containerWidth를 280보다 크게 유지
      containerHeight = 280 + 20 + 30 * 2;
      containerHeight = containerHeight.clamp(280, screenHeight);
    }

    return Container(
      width: 1300,
      height: containerHeight,
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
            Stack(
              children: [
                Container(
                  width: maxWidth,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Color(0XFFd9d9d9),
                      borderRadius: BorderRadius.circular(24)),
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    width: (dataValue * maxWidth).clamp(0, maxWidth),
                    height: 30,
                    decoration: BoxDecoration(
                        color: Color(0XFFffcb39),
                        borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Gap between bars
            // 평균 데이터 막대를 위한 Stack
            Stack(
              children: [
                Container(
                  width: maxWidth,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Color(0XFFd9d9d9),
                      borderRadius: BorderRadius.circular(24)),
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    width: (avgDataValue * maxWidth).clamp(0, maxWidth),
                    height: 30,
                    decoration: BoxDecoration(
                        color: Color(0XFFc4c4c4),
                        borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
