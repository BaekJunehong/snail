import 'package:flutter/material.dart';
import 'package:snail/splash.dart';
import 'package:video_player/video_player.dart';

class StoryVideoScreen extends StatefulWidget {
  @override
  _StoryVideoScreenState createState() => _StoryVideoScreenState();
}

class _StoryVideoScreenState extends State<StoryVideoScreen> {
  late VideoPlayerController _controller;
  bool _isVideoCompleted = false; // 영상 시청 완료 여부

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/story_sample.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        setState(() {
          _isVideoCompleted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              color: Colors.black,
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Center(
                      child: Text(
                        '로딩 중...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
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
