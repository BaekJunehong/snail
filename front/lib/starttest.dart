import 'package:flutter/material.dart';
import 'package:snail/tests/guides/before_test_guide.dart';
import 'package:snail/tests/guides/face_recognition_guide.dart';
import 'package:snail/tests/guides/stroop_guide.dart';
import 'package:snail/tests/guides/chosung_guide.dart';
import 'package:snail/tests/guides/line_guide.dart';
import 'package:snail/tests/guides/voca_rp_guide.dart';
import 'package:snail/tests/guides/story_guide.dart';
import 'package:snail/tests/result/parentdashboard.dart';
import 'package:snail/tests/result/loadingresult.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StartTestScreen extends StatefulWidget {
  @override
  _StartTestScreenState createState() => _StartTestScreenState();
}

class _StartTestScreenState extends State<StartTestScreen> {
  // 검사 가이드 리스트
  final List<Widget Function()> screens = [
    // 검사 전
    () => BeforeTestGuideScreen(),
    () => FaceRecognitionScreen(),
    // 검사
    () => StroopGuideScreen(),
    () => ChosungGuideScreen(),
    () => VocaRepeatGuideScreen(),
    () => LineGuideScreen(),
    () => StoryGuideScreen(),
    // 결과(로딩)
    () => LoadingResultScreen(),
  ];

  num score_stroop = 0;
  num score_line = 0;
  num score_chosung = 0;
  num score_repeat = 0;
  num score_story = 0;
  num score_eyetrack = 0;

  final storage = const FlutterSecureStorage();
  String? user_id;
  String? child_id;
  String? child_name;

  @override
  void initState() {
    super.initState();
    readChildInfo();
  }

  void readChildInfo() async {
    user_id = await storage.read(key: 'USER_ID');
    child_id = await storage.read(key: 'CHILD_ID');
    child_name = await storage.read(key: 'CHILD_NAME');

    // 검사 종료 후 test 데이터 저장 후
    // 만난지 n개월 되었다는 쿼리 작성

    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              // 아이 이름, 개월 수는 DB에서 꺼내 써야 함.
              '${child_name}(이)를 만난 지 N개월이 지났어요!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 25),
            Image.asset(
              './assets/profile.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                // 검사 전 가이드로 이동.
                for (var screen in screens) {        
                  if (screen().runtimeType == LoadingResultScreen) {
                    var url = Uri.https('server-snail.kro.kr:3443', '/saveTestScore');
                    var request = await http.post(url, body: {
                      'SCORE_STROOP': score_stroop.toString(), 
                      'SCORE_LINE': score_line.toString(),
                      'SCORE_CHOSUNG': score_chosung.toString(),
                      'SCORE_REPEAT': score_repeat.toString(),
                      'SCORE_STORY' : score_story.toString(),
                      'SCORE_EYETRACK': score_eyetrack.toString(),
                      'CHILD_ID': child_id,
                    });
                    var data = jsonDecode(request.body);
                    //await storage.write(key: 'RESULT_ID', value: data['id'].toString());
                  }
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen()),
                  );
                  // 유연성, 처리능력, 기억력, 언어능력, 주의력
                  if (screen().runtimeType == StroopGuideScreen) {
                    score_stroop += result[0];
                    score_eyetrack += result[1];
                  }
                  else if (screen().runtimeType == LineGuideScreen) {
                    score_line += result[0];
                  }
                  else if (screen().runtimeType == ChosungGuideScreen) {
                    score_chosung += result[0];
                    score_eyetrack += result[1];
                  }
                  else if (screen().runtimeType == VocaRepeatGuideScreen) {
                    score_repeat += result[0];
                    score_eyetrack += result[1];
                  }
                  else if (screen().runtimeType == StoryGuideScreen) {
                    score_story += result[0];
                    score_eyetrack += result[1];
                  }
                }
              },
              child: Text(
                '시작하기',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFffcb39),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                fixedSize: Size(165, 48),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 검사 전 가이드로 이동.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParentMonthlyDashboardScreen(),
                  ),
                );
              },
              child: Text(
                '부모노트',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFd9d9d9),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                fixedSize: Size(165, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
