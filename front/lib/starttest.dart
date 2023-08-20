import 'package:flutter/material.dart';
import 'package:snail/tests/guides/before_test_guide.dart';
import 'package:snail/tests/guides/stroop_guide.dart';
import 'package:snail/tests/guides/chosung_guide.dart';
import 'package:snail/tests/guides/line_guide.dart';
import 'package:snail/tests/guides/voca_rp_guide.dart';
import 'package:snail/tests/guides/story_guide.dart';
import 'package:snail/tests/result/parentdashboard.dart';
import 'package:snail/tests/tests/chosung_test.dart';

class StartTestScreen extends StatelessWidget {
  // 검사 가이드 리스트
  final List<Widget Function()> screens = [
    () => BeforeTestGuideScreen(),
    () => StroopGuideScreen(),
    () => ChosungGuideScreen(),
    () => VocaRepeatGuideScreen(),
    () => LineGuideScreen(),
    () => StoryGuideScreen(),
  ];

  late int result;

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
              'OO이를 만난 지 N개월이 지났어요!',
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
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen()),
                  );
                  print(result);
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
