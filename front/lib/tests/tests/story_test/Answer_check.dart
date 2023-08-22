import 'package:http/http.dart' as http;
import 'dart:convert';

Future<int> checkAnswers(List<String> answers, int videoNum) async {
  // Python 서버의 URL 설정
  String url = 'https://server-snail.kro.kr:3444/checkAnswer';

  // 요청 본문 생성
  Map<String, dynamic> body = {
    "answers": answers,
    "videoNum": videoNum,
  };

  // POST 요청 전송
  http.Response response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  // 응답 본문 디코딩
  List<bool> result = json.decode(response.body).cast<bool>();

  print('결과 $result');
  print('데이터 형식: ${result.runtimeType}');
  int count = 0;
  for (bool value in result) {
    if (value) {
      count++;
    }
  }
  return count;
}
