import 'package:flutter/material.dart';
import 'package:snail/tests/result/dashboard/linechart.dart';
import 'package:snail/tests/result/dashboard/chartbox.dart';
//버튼 누르면 이동할 페이지
import 'package:snail/tests/result/parentnote.dart';
import 'package:snail/starttest.dart';

class ParentMonthlyDashboardScreen extends StatelessWidget {
  final List<double> currentData = [0.3, 0.5, 0.9, 0.4, 0.8]; //최근 검사 점수
  final List<double> lastMonthData = [0.1, 0.4, 0.5, 0.7, 0.9]; //지난 달 점수

  //역량 이름
  List<String> titleList = [
    '주의력(A)',
    '기억력(B)',
    '처리 능력(C)',
    '언어 능력(D)',
    '유연성(E)',
  ];

  List<String> descriptionList = [
    '외부 자극으로부터 일정 시간동안 지속적으로 주의를 유지하는 능력을 말해요. 한 가지 활동에 집중해야 하는 상황에서 중요한 능력이에요.',
    '정보를 저장하고 꺼내어 활용할 수 있는 능력이에요. 필요한 준비물을 챙기는 것과 같이 수많은 일상 활동들이 기억력과 연관되어 있어요.',
    '정보를 빠르고 정확하게 처리하는 능력을 말해요. 처리 능력은 특히 기본적인 학습 기술인 읽기, 연산 등의 분야와 관련된 능력이에요.',
    '사회의 구성원으로서 사회에서 사용되는 언어를 자연스럽게 사용하는 능력이에요. 일상에서 상대에게 이야기하고 싶은 내용을 잘 전달할 수 있어요.',
    '유연성은 습관화된 반응이나 사고를 극복하고 새로운 상황에 적응하는 능력이에요. 물체, 생각 또는 상황을 동시에 고려할 때 필요한 능력이에요.'
  ];

  @override
  Widget build(BuildContext context) {
    //핵심 역량 = 최근 검사 역량의 점수가 직전 검사 역량의 점수보다 높을 때
    List<Widget> corevaluelist = [];
    for (int i = 0; i < 5; i++) {
      if (currentData[i] > lastMonthData[i]) {
        corevaluelist.add(
          Column(
            children: [
              ChartBox(
                title: titleList[i],
                description: descriptionList[i],
                dataValue: currentData[i],
                avgDataValue: lastMonthData[i],
              ),
              SizedBox(height: 36),
            ],
          ),
        );
      }
    }

    //취약 역량 = 최근 검사 역량의 점수가 직전 검사 역량의 점수보다 낮을 때
    List<Widget> weakvaluelist = [];
    for (int i = 0; i < 5; i++) {
      if (currentData[i] < lastMonthData[i]) {
        weakvaluelist.add(
          Column(
            children: [
              ChartBox(
                title: titleList[i],
                description: descriptionList[i],
                dataValue: currentData[i],
                avgDataValue: lastMonthData[i],
              ),
              SizedBox(height: 36),
            ],
          ),
        );
      }
    }

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
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 1400,
                    child: LineChartSample2(),
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
                      '지난 달과 비교해',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
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
                  Container(
                    width: 1300,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '이 역량이 발달했어요!',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 20),
                  //핵심역량 ChartBox 렌더링
                  ...corevaluelist,
                  SizedBox(height: 100),
                  Container(
                    width: 1300,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '이 역량은 조금만 지켜봐주세요!',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 20),
                  //취약역량 ChartBox 렌더링
                  ...weakvaluelist,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (ParentNoteScreen())));
                        },
                        child: Text(
                          '최근 검사',
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (StartTestScreen())));
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
                  SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
