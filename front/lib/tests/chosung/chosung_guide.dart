import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          MyWidget(),
        ]),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1440,
          height: 960,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 4.50,
                top: 44.50,
                child: Container(
                  width: 1436,
                  height: 917.50,
                  child: Stack(children: [
                    // Add your widgets here
                  ]),
                ),
              ),
              Positioned(
                left: -1,
                top: 54,
                child: Container(
                  width: 1441,
                  height: 908,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 1440,
                          height: 795,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://via.placeholder.com/1440x795"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 1441,
                        top: 908,
                        child: Transform(
                          transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                          child: Container(
                            width: 1440,
                            height: 377,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("https://via.placeholder.com/1440x377"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 289,
                top: 203,
                child: Container(
                  width: 862,
                  height: 554,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 862,
                          height: 554,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 148,
                        top: 51,
                        child: Container(
                          width: 566,
                          height: 133,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 113,
                                child: SizedBox(
                                  width: 566,
                                  child: Text(
                                    '화면에서 보여주는 자음으로 시작하는 단어를 최대한 많이 말해주세요!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                      letterSpacing: -0.40,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 207,
                                top: 0,
                                child: Text(
                                  '단어 유창성',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 32,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                    letterSpacing: -0.64,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 95,
                                top: 54,
                                child: SizedBox(
                                  width: 376,
                                  child: Text(
                                    '소요 시간: NN분',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                      letterSpacing: -0.40,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 823,
                top: 416,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 157,
                        height: 52,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 87,
                              top: 52,
                              child: Transform(
                                transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(3.14),
                                child: Container(
                                  width: 17,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 61,
                              top: 13,
                              child: Text(
                                '고기',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 13),
                      Container(
                        width: 139,
                        height: 184,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("https://via.placeholder.com/139x184"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 502,
                top: 490,
                child: Text(
                  'ㄱ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 100,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: -2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
