import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snail/splash.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'story_test.dart';

class StoryTest extends StatefulWidget {
  @override
  _StoryTestState createState() => _StoryTestState();
}

class _StoryTestState extends State<StoryTest> {
  //영상은 url로 가져오고 영상 관련 이미지는 asset에 저장.
  //1. 우리끼리 가자 2. 내 꿈은 무슨 색일까
  List<String> VideoUrl = [
    'https://www.nlcy.go.kr/multiLanguageStory/2011/Nlcy_007_005/Nlcy_007_005.mp4',
    'https://www.nlcy.go.kr/multiLanguageStory/2011/Nlcy_010_002/Nlcy_010_002.mp4'
  ];

  List<String> videoImg = ['go_with_me.png', 'what_is_my_dream_color.png'];

  int videoNumber = 0;
  String videoUrl = '';
  bool _isVideoCompleted = false;

  int randomIndex = 0;

  @override
  void initState() {
    super.initState();

    //video 랜덤 실행
    Random random = Random();
    int randomIndex = random.nextInt(VideoUrl.length);
    videoUrl = VideoUrl[randomIndex];

    setState(() {
      videoNumber = randomIndex;
    });
    _isVideoCompleted = false;
    playVideo(videoUrl);

    //04분 후 활성화
    Timer(Duration(milliseconds: 1), () {
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
      body: Stack(
        children: [
          Container(
            width: double.infinity, // 컨테이너를 화면 너비에 맞게 설정
            // height: double.infinity, // 컨테이너를 화면 높이에 맞게 설정
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_story.png'),
                fit: BoxFit.fill, // 이미지를 컨테이너에 꽉 채우도록 설정
              ),
            ),
          ),
          Center(
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
                GestureDetector(
                  onTap: () {
                    playVideo(videoUrl);
                  },
                  child: Image.asset(
                    videoImg[videoNumber],
                    width: 700,
                    height: 430,
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
                                  builder: (context) => (StoryTestScreen(
                                      videoNum: videoNumber))));
                        }
                      : null,
                  child: Text(
                    '시작하기',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: _isVideoCompleted
                        ? Color(0XFFffcb39)
                        : Color(0XFFd9d9d9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    fixedSize: Size(165, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
