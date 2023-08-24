import 'package:flutter/material.dart';
import 'package:snail/audio.dart';
import 'package:snail/tests/result/parentdashboard.dart';
import 'package:snail/tests/result/dashboard/radarchart.dart'; //방사형 그래프 렌더링
import 'package:snail/tests/result/dashboard/gptfeedbackbox.dart'; // gpt 피드백 입력란
import 'package:snail/tests/result/dashboard/chartbox.dart'; // 역량 설명 및 막대 그래프 템플릿 렌더링
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParentNoteScreen extends StatefulWidget {
  @override
  _ParentNoteScreenState createState() => _ParentNoteScreenState();
}

class _ParentNoteScreenState extends State<ParentNoteScreen> {
  //레이더 차트에 렌더링되는 데이터
  List<double> data = [0.8, 0.6, 0.9, 0.4, 0.7]; //아이의 검사 결과 여기에 저장
  final List<double> avgData = [0.5, 0.5, 0.5, 0.5, 0.5]; //연령대 평균 점수 여기에 저장
  final int levels = 5;
  final int numberOfPolygons = 10;
  String feedback = '';

  final storage = const FlutterSecureStorage();
  void getScore() async {
    final child_id = await storage.read(key: 'CHILD_ID');

    var url = Uri.https('server-snail.kro.kr:3443', '/getLastResultID');
    var request = await http.post(url, body: {'CHILD_ID': child_id});
    var record = jsonDecode(request.body)[0];
    final result_id = record['RESULT_ID'].toString();

    var lastUrl = Uri.https('server-snail.kro.kr:3443', '/getScores');
    var lastRequest = await http.post(lastUrl, body: {'RESULT_ID': result_id});
    var lastRecord = jsonDecode(lastRequest.body)[0];

    data[0] = lastRecord['EYETRACK_PERC'] / 100;
    data[1] = lastRecord['VOCA_RP_PERC'] / 100;
    data[2] = lastRecord['CHOSUNG_PERC'] / 100;
    data[3] = lastRecord['STORY_PERC'] / 100;
    data[4] = (lastRecord['STROOP_PERC'] + lastRecord['LINE_PERC']) / 200;
    setState(() {
      feedback = lastRecord['FEEDBACK'];
    });
  }

  // A: 주의력, B: 기억력, C: 처리 능력, D: 언어 능력, E: 유연성
  // 매칭만 되면 되니 인덱스 순서는 백, 모델링 단에서 원하시는 대로 처리하시면 됩니다!
  final List<String> labels = ['A', 'B', 'C', 'D', 'E'];

  //dataColor: 아이, avgColor: 연령대 평균
  final dataColor = Color(0XFFFFCB39);
  final avgColor = Color(0XFFD9D9D9);

  @override
  void initState() {
    super.initState();
    getScore();
  }

  @override
  Widget build(BuildContext context) {
    final double grayBoxWidth = 765;
    final double grayBoxHeight = 400;
    final double paddingValue = 60; //여백

    return Scaffold(body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double screenWidth = constraints.maxWidth;
        final bool isSmallScreen = screenWidth < 800;
        return SingleChildScrollView(
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
                        '달이의 AI 리포트', //아이 이름 DB에서 꺼내와야 함.
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 70),
                    isSmallScreen
                        ? Column(
                            children: [
                              PentagonRadarChart(
                                  data: data,
                                  avgData: avgData,
                                  levels: levels,
                                  numberOfPolygons: numberOfPolygons,
                                  labels: labels,
                                  dataColor: dataColor,
                                  avgColor: avgColor),
                              SizedBox(width: paddingValue),
                              SizedBox(height: 50),
                              GPTFeedbackBox(
                                text: feedback,
                              ),
                              SizedBox(width: paddingValue),
                            ],
                          )
                        : Row(
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
                              GPTFeedbackBox(
                                text: feedback,
                              ),
                              SizedBox(width: paddingValue),
                            ],
                          ),
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
                        '항목별 피드백',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      //라벨!
                      Container(
                          color: Color(0xFFffcb39), width: 55, height: 20),
                      SizedBox(width: 7),
                      Text('자녀'),
                      SizedBox(width: 10),
                      Container(
                          color: Color(0xFFc4c4c4), width: 55, height: 20),
                      SizedBox(width: 7),
                      Text('연령대 평균'),
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
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ParentMonthlyDashboardScreen()),
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            '대시보드',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFffcb39),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            fixedSize: Size(165, 48),
                          ),
                        ),
                        SizedBox(width: 120),
                        ElevatedButton(
                          onPressed: () async {
                            //await storage.delete(key: 'RESULT_ID');
                            Navigator.pop(context);
                          },
                          child: Text(
                            '돌아가기',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFd9d9d9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            fixedSize: Size(165, 48),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100)
                  ],
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
