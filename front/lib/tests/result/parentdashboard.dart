import 'package:flutter/material.dart';
import 'package:snail/tests/result/dashboard/linechart.dart';
import 'package:snail/tests/result/dashboard/chartbox.dart';

class ParentMonhlyDashboardScreen extends StatelessWidget {
  final List<double> data = [0.3, 0.5, 0.9, 0.9, 0.8]; //이번 달 점수
  final List<double> avgData = [0.1, 0.4, 0.5, 0.7, 0.9]; //지난 달 점수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 70),
              Column(
                children: [
                  Container(
                    width: 1300,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '달이의 AI 대시보드', //아이 이름 DB에서 꺼내와야 함.
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 70),
                  LineChartSample2(),
                ],
              ),
              SizedBox(height: 126),
              Container(
                width: 1300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      '핵심 역량',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    //라벨!
                    Container(color: Color(0xFFffcb39), width: 55, height: 20),
                    SizedBox(width: 7),
                    Text('최근 검사'),
                    SizedBox(width: 10),
                    Container(color: Color(0xFFc4c4c4), width: 55, height: 20),
                    SizedBox(width: 7),
                    Text('지난 검사'),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  ChartBox(
                    title: '주의력(A)',
                    description:
                        '외부 자극으로부터 일정 시간동안 지속적으로 주의를 유지하는 능력을 말해요. 한 가지 활동에 집중해야 하는 상황에서 중요한 능력이에요.',
                    dataValue: data[0],
                    avgDataValue: avgData[0],
                  ),
                  SizedBox(height: 36), // 각 차트 박스 사이 간격 조절
                  ChartBox(
                    title: '기억력(B)',
                    description:
                        '정보를 저장하고 꺼내어 활용할 수 있는 능력이에요. 필요한 준비물을 챙기는 것과 같이 수많은 일상 활동들이 기억력과 연관되어 있어요.',
                    dataValue: data[1],
                    avgDataValue: avgData[1],
                  ),
                  SizedBox(height: 36),
                  ChartBox(
                    title: '처리 능력(C)',
                    description:
                        '정보를 빠르고 정확하게 처리하는 능력을 말해요. 처리 능력은 특히 기본적인 학습 기술인 읽기, 연산 등의 분야와 관련된 능력이에요.',
                    dataValue: data[2],
                    avgDataValue: avgData[2],
                  ),
                  SizedBox(height: 70),
                  Text(
                    '취약역량',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ChartBox(
                    title: '기억력(B)',
                    description:
                        '정보를 저장하고 꺼내어 활용할 수 있는 능력이에요. 필요한 준비물을 챙기는 것과 같이 수많은 일상 활동들이 기억력과 연관되어 있어요.',
                    dataValue: data[1],
                    avgDataValue: avgData[1],
                  ),
                  SizedBox(height: 36),
                  ChartBox(
                    title: '처리 능력(C)',
                    description:
                        '정보를 빠르고 정확하게 처리하는 능력을 말해요. 처리 능력은 특히 기본적인 학습 기술인 읽기, 연산 등의 분야와 관련된 능력이에요.',
                    dataValue: data[2],
                    avgDataValue: avgData[2],
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        '돌아가기',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFffcb39),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        fixedSize: Size(165, 48),
                      )),
                  SizedBox(height: 100)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
