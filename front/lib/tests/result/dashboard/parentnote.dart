import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snail/tests/result/dashboard/dashboard.dart';
import 'package:fl_chart/fl_chart.dart';

class ParentNoteScreen extends StatelessWidget {
  //레이더 차트에 렌더링되는 데이터
  final List<double> data = [0.8, 0.6, 0.9, 0.4, 0.7]; //아이의 검사 결과 여기에 저장
  final List<double> avgData = [0.5, 0.5, 0.5, 0.5, 0.5]; //연령대 평균 점수 여기에 저장
  final int levels = 5;
  final int numberOfPolygons = 10;
  final List<String> labels = ['A', 'B', 'C', 'D', 'E'];
  final dataColor = Color(0XFFFFCB39);
  final avgColor = Color(0XFFD9D9D9);

  @override
  Widget build(BuildContext context) {
    final double grayBoxWidth = 765;
    final double grayBoxHeight = 400;
    final double paddingValue = 60; //여백

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 200),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: PentagonRadarChart(
                        data: data,
                        avgData: avgData,
                        levels: levels,
                        numberOfPolygons: numberOfPolygons,
                        labels: labels,
                        dataColor: dataColor,
                        avgColor: avgColor,
                      ),
                    ),
                  ),
                  SizedBox(width: paddingValue),
                  //GPT 피드백 입력란
                  Container(
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
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
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
                  ),
                  SizedBox(width: paddingValue),
                ],
              ),
              SizedBox(height: 200),
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
                  SizedBox(height: 36),
                  ChartBox(
                    title: '언어 능력(D)',
                    description:
                        '사회의 구성원으로서 사회에서 사용되는 언어를 자연스럽게 사용하는 능력이에요. 일상에서 상대에게 이야기하고 싶은 내용을 잘 전달할 수 있어요.',
                    dataValue: data[3],
                    avgDataValue: avgData[3],
                  ),
                  SizedBox(height: 36),
                  ChartBox(
                    title: '유연성(E)',
                    description:
                        '유연성은 습관화된 반응이나 사고를 극복하고 새로운 상황에 적응하는 능력이에요. 물체, 생각 또는 상황을 동시에 고려할 때 필요한 능력이에요.',
                    dataValue: data[4],
                    avgDataValue: avgData[4],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
