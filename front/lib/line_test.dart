import 'package:flutter/material.dart';
import 'dart:math';

class LineTest extends StatefulWidget {
  @override
  _LineTestState createState() => _LineTestState();
}

class _LineTestState extends State<LineTest> {
  final Random _random = Random();
  final List<Offset> _positions = List.generate(7, (index) => Offset.zero);
  final List<Color> _circleColors = List.generate(7, (index) => Colors.grey);
  final List<int> _selectedIndices = [];
  double minDistance = 200; // 최소 거리 조절
  bool _isMousePressed = false;
  bool _isAnswerCorrect = false;

  //원 생성
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 7; i++) {
      generateNonOverlappingPosition(i);
    }
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
          isCorrect = false;
          break;
        }
      }
      setState(() {
        _isAnswerCorrect = isCorrect;
      });
    }
    print(_isAnswerCorrect);
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedIndices);
    return Scaffold(
      body: Center(
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
                    onEnter: (_) {
                      if (_isMousePressed &&
                          !_selectedIndices.contains(index)) {
                        setState(() {
                          _circleColors[index] = Colors.yellow;
                          _selectedIndices.add(index);
                          if (_selectedIndices.length == 7) {
                            CheckAnswer(_selectedIndices);
                          }
                        });
                      }
                    },
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isMousePressed = !_isMousePressed;
                      }),
                      child: Container(
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
            ],
          ),
        ),
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
      ..color = Colors.black
      ..strokeWidth = 2;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
