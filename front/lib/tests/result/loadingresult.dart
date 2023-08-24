import 'package:flutter/material.dart';
import 'package:snail/tests/result/parentnote.dart';

class LoadingResultScreen extends StatefulWidget {
  @override
  _LoadingResultScreenState createState() => _LoadingResultScreenState();
}

class _LoadingResultScreenState extends State<LoadingResultScreen> {
  bool _showButton = false;
  String _displayText = '게임 결과를 불러오고 있어요.\n잠시만 기다려주세요.'; // 줄바꿈 추가

  @override
  void initState() {
    super.initState();
    // 10초 후에 버튼을 보여주고 텍스트 변경
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _showButton = true;
        _displayText = '게임 결과를 저장했어요!'; // 텍스트 변경
      });
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
