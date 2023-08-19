import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snail/splash.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';

class StoryTest extends StatefulWidget {
  @override
  _StoryTestState createState() => _StoryTestState();
}

class _StoryTestState extends State<StoryTest> {
  //영상은 url로 가져오고 영상 관련 이미지는 asset에 저장.
  //list = [url,이미지,[문제,답]]로 생성으로 할 듯 합니다.

  String videoUrl =
      'https://www.nlcy.go.kr/multiLanguageStory/2022/Nlcy_001_003/Nlcy_001_003_ko.mp4'; // 예시 URL
  bool _isVideoCompleted = false;

  @override
  void initState() {
    super.initState();
    _isVideoCompleted = false;
    playVideo(videoUrl);

    //04분 후 활성화
    Timer(Duration(minutes: 4), () {
      setState(() {
        _isVideoCompleted = true;
      });
    });
  }

  void playVideo(String videoUrl) {
    if (kIsWeb) {
      final v = html.window.document.getElementById('videoPlayer');
      if (v != null) {
        v.setInnerHtml('<source type="video/mp4" src="$videoUrl">',
            validator: html.NodeValidatorBuilder()
              ..allowElement('source', attributes: ['src', 'type']));
        final a = html.window.document.getElementById('triggerVideoPlayer');
        if (a != null) {
          a.dispatchEvent(html.MouseEvent('click'));
        }
      }
    }
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
              '영상을 보고 이야기를 나눠봐요!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 872,
              height: 539,
              child: Image.asset(
                'story_sample.png',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _isVideoCompleted
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (SplashScreen())));
                    }
                  : null,
              child: Text(
                '시작하기',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                primary:
                    _isVideoCompleted ? Color(0XFFffcb39) : Color(0XFFd9d9d9),
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
