import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultDashboardScreen extends StatelessWidget {
  final List<FlSpot> radarChartData;

  ResultDashboardScreen({required this.radarChartData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: RadarChart(
            RadarChartData(
              // 레이더 차트를 그리는데 필요한 설정
              radarBackgroundColor: Colors.grey[200], // 레이더 차트의 배경색 설정
              borderData: FlBorderData(show: true), // 레이더 차트 테두리 보이도록 설정
              // borderColor: Colors.grey, // 레이더 차트 테두리 색상 설정
              // gridData: FlGridData(show: true), // 레이더 차트 눈금(그리드) 보이도록 설정
              // gridColor: Colors.grey, // 레이더 차트 눈금(그리드) 색상 설정
              // touchData: FlTouchData(enabled: false), // 터치 이벤트 비활성화
              // titlesData: FlTitlesData(show: false), // 타이틀 비활성화
              // radarData: [
              //   RadarLine(
              //     spots: radarChartData,
              //     isCurved: true, // 곡선으로 레이더 차트 그리기
              //     colors: [Colors.blue], // 레이더 차트 선 색상 설정
              //     strokeWidth: 2.0, // 레이더 차트 선 굵기 설정
              //     dotData: FlDotData(show: false), // 데이터 점 비활성화
              //   ),
              // ],
            ),
          ),
        ),
      ),
    );
  }
}
