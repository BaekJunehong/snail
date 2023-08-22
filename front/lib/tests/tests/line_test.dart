import 'package:flutter/material.dart';
import 'dart:math';
import 'package:snail/tests/correct_sign.dart';
import 'package:snail/tests/count_down.dart';
import 'package:snail/tests/eyetracking.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class LineTest extends StatefulWidget {
  @override
  _LineTestState createState() => _LineTestState();
}

class _LineTestState extends State<LineTest> {
  //원 생성 관련 변수
  final Random _random = Random();
  final List<Offset> _positions = List.generate(7, (index) => Offset.zero);
  final List<Color> _circleColors =
      List.generate(7, (index) => Color(0xFFD9D9D9));
  final List<int> _selectedIndices = [];
  double minDistance = 200; // 최소 거리 조절
  bool MousePressed = false;
  bool isCorrected = false;

  //countdown 관련 변수
  bool isVisible = true;
  int countdownSeconds = 3; // Countdown seconds
  Timer? countdownTimer; // Countdown timer
  bool _isRunning = true; //true일때 countdown

  //game time
  Timer? timer; // 타이머
  int seconds = 0; // 경과 초
  int time = 0; // 시행 횟수

  int test_total_time = 180; // 테스트 총 시간

  int correctCount = 0;

  late CameraController _controller;
  late var imgSender;

  //원 생성
  @override
  void initState() {
    super.initState();
    openCamera();

    for (int i = 0; i < 7; i++) {
      generateNonOverlappingPosition(i);
    }
    // 3초 카운트, 3초 뒤 안보이게
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isVisible = false;
      });
    });

    // 3초 카운트다운 타이머
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          // 카운트다운이 끝나면 시작
          countdownTimer?.cancel(); // Cancel the countdown timer
          _isRunning = true;
          //startTestTimer();
        }
      });
    });
  }

  Future<void> openCamera() async {
    _controller = await initializeCamera();

    imgSender = FaceImgSender(_controller);
    imgSender.startSending();
  }

  void startTestTimer() {
    // 1초마다 타이머 콜백
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_isRunning) {
          seconds++; // 경과 시간(초) 갱신
          time += 1;
          countdownSeconds = 3;
          // isVisible = true;
          _isRunning = false;
          if (time == test_total_time) {
            int etCount = imgSender.stopSending();
            Navigator.pop(context, [correctCount, etCount]);
          }
        } else {
          if (countdownSeconds > 1) {
            countdownSeconds--;
          } else {
            // isVisible = false;
            _isRunning = true;
          }
        }
      });
    });
  }

  //원을 랜덤한 위치에 지정
  void generateNonOverlappingPosition(int index) {
    bool isOverlapping;
    do {
      isOverlapping = false;
      _positions[index] = Offset(
        _random.nextDouble() * (862 - 100), // Adjusted for circle size
        _random.nextDouble() * (554 - 100), // Adjusted for circle size
      );
      for (int i = 0; i < index; i++) {
        if ((_positions[i] - _positions[index]).distance < minDistance) {
          isOverlapping = true;
          break;
        }
      }
    } while (isOverlapping);
  }

  void CheckAnswer(List list) {
    bool isCorrect = true;
    if (_selectedIndices.length == 7) {
      for (int i = 0; i < 7; i++) {
        if (_selectedIndices[i] != i) {
          setState(() {
            isCorrect = false;
          });
        }
      }
      if (isCorrect == true) {
        correctCount += 1;
      }
      setState(() {
        isCorrected = isCorrect;
        MousePressed = false;
        Future.delayed(Duration(seconds: 2), () {
          resetTest();
        });
      });
    }
    print(correctCount);
  }

  void resetTest() {
    setState(() {
      _selectedIndices.clear(); // 정답 상태 초기화
      _circleColors.clear();

      for (int i = 0; i < 7; i++) {
        generateNonOverlappingPosition(i);
        _circleColors.add(Color(0xFFD9D9D9));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedIndices);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/background/background_line.png', // 배경 이미지 파일 경로
            fit: BoxFit.fill,
            width: double.infinity, // 너비를 전체 화면으로 설정
            // height: double.infinity,
          ),
          Center(
            child: Container(
              width: 862,
              height: 554,
              child: Stack(
                children: [
                  if (_selectedIndices.length >= 2)
                    ...List.generate(
                      _selectedIndices.length - 1,
                      (index) => Positioned.fill(
                        child: CustomPaint(
                          painter: LinePainter(
                            start: _positions[_selectedIndices[index]] +
                                Offset(50, 50), // Adjusted for circle size
                            end: _positions[_selectedIndices[index + 1]] +
                                Offset(50, 50), // Adjusted for circle size
                          ),
                        ),
                      ),
                    ),
                  ...List.generate(
                    7,
                    (index) => Positioned(
                      left: _positions[index].dx,
                      top: _positions[index].dy,
                      child: MouseRegion(
                        onHover: (_) {
                          // print(33);
                          // print(!_selectedIndices.contains(index));
                          // print(MousePressed);
                          MousePressed = true;
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (MousePressed &&
                                !_selectedIndices.contains(index)) {
                              setState(() {
                                print(11);
                                _circleColors[index] = Color(0xFFffcb39);
                                MousePressed = false;
                                _selectedIndices.add(index);
                                if (_selectedIndices.length == 7) {
                                  CheckAnswer(_selectedIndices);
                                }
                              });
                            }
                          },
                          child: isVisible
                              ? null
                              : Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _circleColors[index],
                                  ),
                                  child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Visibility(
                        visible: isVisible,
                        child: Center(
                          child: CountdownTimer(seconds: 3),
                        )),
                  ),
                  if (_selectedIndices.length == 7 && isCorrected)
                    Positioned(
                      child: Center(
                        child: correctSign(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  LinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFC9980D)
      ..strokeWidth = 2;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
