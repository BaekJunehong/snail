import 'package:flutter/material.dart';
import 'package:snail/tests/result/parentnote.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart' as xml2json;
import 'dart:convert';

class LoadingResultScreen extends StatefulWidget {
  @override
  _LoadingResultScreenState createState() => _LoadingResultScreenState();
}

class _LoadingResultScreenState extends State<LoadingResultScreen> {
  final storage = const FlutterSecureStorage();

  bool _showButton = false;
  String _displayText = '게임 결과를 불러오고 있어요.\n잠시만 기다려주세요.'; // 줄바꿈 추가

  @override
  void initState() {
    super.initState();
    getAiFeedback();
  }

  String getPercScore (double perc) {
    if (perc > 0.75) {
      return '좋음';
    }
    else if (perc < 0.25) {
      return '나쁨';
    }
    else {
      return '보통';
    }
  }

  void getAiFeedback() async {
    final child_name = await storage.read(key: 'CHILD_NAME');
    final result_id = await storage.read(key: 'RESULT_ID');
    await storage.delete(key: 'RESULT_ID'); 

    var lastUrl = Uri.https('server-snail.kro.kr:3443', '/getScores');
    var lastRequest = await http.post(lastUrl, body: {'RESULT_ID': result_id});
    var lastRecord = jsonDecode(lastRequest.body)[0];

    var param = {
      'CHILD_NAME': child_name,
      // 주의력
      'score1': getPercScore(lastRecord['EYETRACK_PERC'] / 100),
      // 기억력
      'score2': getPercScore(lastRecord['VOCA_RP_PERC'] / 100),
      // 처리능력
      'score3': getPercScore(lastRecord['CHOSUNG_PERC']  / 100),
      // 언어능력
      'score4': getPercScore(lastRecord['STORY_PERC'] / 100),
      // 유연성
      'score5': getPercScore((lastRecord['STROOP_PERC'] + lastRecord['LINE_PERC']) / 200),
    };

    var fbUrl = Uri.https('server-snail.kro.kr:3444', '/requestFeedback');
    var fbRequest = await http.post(
      fbUrl, 
      body: jsonEncode(param),
      headers: {"Content-Type": "application/json"},
    );
    var feedbackText = jsonDecode(fbRequest.body);

    var url = Uri.https('server-snail.kro.kr:3443', '/saveFeedback');
    var request = await http.post(url, body: {'RESULT_ID': result_id.toString(), 'FEEDBACK': feedbackText});

    // 피드백 저장 후 상태 변경
    setState(() {
      _showButton = true;
      _displayText = '게임 결과를 저장했어요!'; // 텍스트 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/pattern.png', fit: BoxFit.fill),
          ),
          Center(
            child: Container(
              //모달
              width: 862,
              height: 554,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/loading.gif',
                      width: 478,
                    ),
                    SizedBox(height: 20),
                    Text(
                      _displayText, // 변경된 텍스트 표시
                      textAlign: TextAlign.center, // 가운데 정렬
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 20),
                    // 버튼을 보여주는지 여부에 따라 조건부로 보여줌
                    if (_showButton)
                      ElevatedButton(
                          onPressed: () async {
                            // 결과 보기 버튼을 누를 때 처리
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ParentNoteScreen()),
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            '결과 보기',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFffcb39),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            fixedSize: Size(165, 48),
                          )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
