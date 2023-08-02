import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'resultdashboard.dart'; // ResultDashboardScreen을 import

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('First Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 두 번째 화면인 ResultDashboardScreen을 보여줌
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultDashboardScreen(
                  radarChartData: [
                    FlSpot(1, 0.8),
                    FlSpot(2, 0.6),
                    FlSpot(3, 0.9),
                    FlSpot(4, 0.5),
                    FlSpot(5, 0.4),
                  ],
                ),
              ),
            );
          },
          child: Text('Show Radar Chart'),
        ),
      ),
    );
  }
}
