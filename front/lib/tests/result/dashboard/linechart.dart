import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({Key? key}) : super(key: key);

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  bool showAvg = false;

  // 예시 데이터
  // 순서대로 1~12월 데이터라 생각해주세요!
  final List<List<double>> monthlyData = [
    [0.5, 0.6, 0.8, 0.9, 1.0], //1월
    [0.1, 0.4, 0.5, 0.7, 0.9], //2월
    [0.3, 0.5, 0.9, 1.0, 0.8], //3월
    [0.5, 0.6, 0.8, 0.9, 1.0], //4월
    [0.6, 0.4, 0.5, 0.7, 0.2], //5월
    [0.5, 0.6, 0.8, 0.9, 1.0], //6월
    [0.1, 0.4, 0.5, 0.7, 0.9], //7월
    [0.3, 0.5, 0.9, 1.0, 0.8], //8월
    [0.5, 0.6, 0.8, 0.9, 1.0], //9월
    [0.6, 0.4, 0.5, 0.7, 0.2], //10월
    [0.5, 0.6, 0.8, 0.9, 1.0], //1월
    [0.1, 0.4, 0.5, 0.7, 0.9], //2월
  ];

  //평균으로 변환하는 함수
  List<FlSpot> getMonthlyAverage(int month) {
    final data = monthlyData[month];
    final average = data.fold(0.0, (sum, value) => sum + value) / data.length;
    return List.generate(
      data.length,
      //역량에 100을 곱한 후, 해당 월의 데이터를 적용
      (index) => FlSpot(index.toDouble(), average * 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    List<FlSpot> allSpots = []; // 꺾은선 그래프 저장
    //1월~5월
    for (int monthIndex = 0; monthIndex < 12; monthIndex++) {
      final average =
          monthlyData[monthIndex].fold(0.0, (sum, value) => sum + value) /
              monthlyData[monthIndex].length;
      allSpots.add(FlSpot(monthIndex.toDouble(), average * 100)); //월별 평균 데이터
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        verticalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0XFFd9d9d9),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitles: (value) {
            final monthLabels = [
              '1월',
              '2월',
              '3월',
              '4월',
              '5월',
              '6월',
              '7월',
              '8월',
              '9월',
              '10월',
              '11월',
              '12월',
            ];
            final monthIndex = value.toInt();
            if (monthIndex >= 0 && monthIndex < monthLabels.length) {
              return monthLabels[monthIndex];
            }
            return '';
          },
          interval: 1,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 10,
          reservedSize: 100,
          getTitles: (value) {
            return '${value.toInt()}';
          },
        ),
        rightTitles: SideTitles(
          showTitles: false,
        ),
        topTitles: SideTitles(
          showTitles: false, // 차트 위의 숫자 표시 비활성화
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xffffff)),
      ),
      minX: 0,
      maxX: monthlyData.length.toDouble() - 1,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
            spots: allSpots,
            isCurved: true,
            colors: [Color(0XFFffcb39)],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(show: true, colors: [
              Color(0XFFffcb39).withOpacity(0.3),
              Colors.white.withOpacity(0.3)
            ]))
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: false,
        verticalInterval: 20,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xffd9d9d9),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xffd9d9d9),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xffd9d9d9)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 120,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [Color(0XFFffcb39)],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [
              Color(0XFFffcb39).withOpacity(0.3),
              Colors.white.withOpacity(0.3)
            ],
          ),
        ),
      ],
    );
  }
}
