import 'dart:math';
import 'package:flutter/material.dart';
import './dashboard.dart';

class ParentNoteScreen extends StatelessWidget {
  final List<double> data = [0.8, 0.6, 0.9, 0.4, 0.7]; //아이의 검사 결과 여기에 저장
  final List<double> avgData = [0.5, 0.5, 0.5, 0.5, 0.5]; //연령대 평균 점수 여기에 저장
  final int levels = 5;
  final int numberOfPolygons = 10;
  final List<String> labels = ['A', 'B', 'C', 'D', 'E'];
  final dataColor = Color(0XFFFFCB39);
  final avgColor = Color(0XFFD9D9D9);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double grayBoxWidth = 765;
    final double grayBoxHeight = 400;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                // padding: EdgeInsets.only(right: 150), // 오른쪽에 패딩 추가
                child: RadarChart(
                  data: data,
                  avgData: avgData,
                  levels: levels,
                  numberOfPolygons: numberOfPolygons,
                  labels: labels,
                  dataColor: dataColor,
                  avgColor: avgColor,
                ),
              ),
              // Container(
              //   width: grayBoxWidth,
              //   height: grayBoxHeight,
              //   color: Colors.grey,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
