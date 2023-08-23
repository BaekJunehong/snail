import 'package:flutter/material.dart';
import 'package:snail/tests/result/dashboard/linechart.dart';
import 'package:snail/tests/result/dashboard/chartbox.dart';
import 'package:snail/tests/result/parentnote.dart';
import 'package:snail/tests/result/noresults.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParentMonthlyDashboardScreen extends StatefulWidget {
  @override
  _ParentMonthlyDashboardScreenState createState() => _ParentMonthlyDashboardScreenState();
}

class _ParentMonthlyDashboardScreenState extends State<ParentMonthlyDashboardScreen> {
  List<double> currentData = [0.3, 0.5, 0.9, 0.4, 0.8]; //최근 검사 점수
  List<double> lastMonthData = [0.0, 0.0, 0.0, 0.0, 0.0]; //지난 달 점수

  final storage = const FlutterSecureStorage();
    void getLastScore () async {
      final child_id = await storage.read(key: 'CHILD_ID');

      var url = Uri.https('server-snail.kro.kr:3443', '/getLastResultID');
      var request = await http.post(url, body: {'CHILD_ID': child_id});
      if (jsonDecode(request.body).isEmpty) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoResultScreen()),
        );
        Navigator.pop(context);
      }
      else {
        var record = jsonDecode(request.body)[0];
        final result_id = record['RESULT_ID'].toString();

        var lastUrl = Uri.https('server-snail.kro.kr:3443', '/getScores');
        var lastRequest = await http.post(lastUrl, body: {'RESULT_ID': result_id});
        var lastRecord = jsonDecode(lastRequest.body)[0];
        
        currentData[0] = lastRecord['EYETRACK_PERC'] / 100;
        currentData[1] = lastRecord['VOCA_RP_PERC'] / 100;
        currentData[2] = lastRecord['CHOSUNG_PERC'] / 100;
        currentData[3] = lastRecord['STORY_PERC'] / 100;
        currentData[4] = (lastRecord['STROOP_PERC'] + lastRecord['LINE_PERC']) / 200;

        setState(() {});
      }
    }

  void getLastMonthScore () async {
      final child_id = await storage.read(key: 'CHILD_ID');

      var url = Uri.https('server-snail.kro.kr:3443', '/getLastMonthResultID');
      var request = await http.post(url, body: {'CHILD_ID': child_id});
      if (jsonDecode(request.body).isNotEmpty) {
        var record = jsonDecode(request.body)[0];
        final result_id = record['RESULT_ID'].toString();

        var monthUrl = Uri.https('server-snail.kro.kr:3443', '/getScores');
        var monthRequest = await http.post(monthUrl, body: {'RESULT_ID': result_id});
        var monthRecord = jsonDecode(monthRequest.body)[0];
        
        lastMonthData[0] = monthRecord['EYETRACK_PERC'] / 100;
        lastMonthData[1] = monthRecord['VOCA_RP_PERC'] / 100;
        lastMonthData[2] = monthRecord['CHOSUNG_PERC'] / 100;
        lastMonthData[3] = monthRecord['STORY_PERC'] / 100;
        lastMonthData[4] = (monthRecord['STROOP_PERC'] + monthRecord['LINE_PERC']) / 200;

        setState(() {});
      }
    }

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
  void initState() {
    super.initState();
    getLastScore();
    getLastMonthScore();
  }

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
                  weakvaluelist.isEmpty
                    ? Container()  // weakvaluelist가 비어있을 때 빈 컨테이너를 반환합니다.
                    : Container(
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
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ParentNoteScreen()),
                          );
                          Navigator.pop(context);
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
