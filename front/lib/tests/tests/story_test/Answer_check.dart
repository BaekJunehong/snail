import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<bool>> checkAnswers(List<String> answers, int videoNum) async {
  // Python 서버의 URL 설정
  String url = 'https://server-snail.kro.kr:3444/checkAnswer';
  print('checkAnswers connect');
  // 요청 본문 생성
  Map<String, dynamic> body = {
    "answers": answers,
    "videoNum": videoNum,
  };
  print('요청');
  // POST 요청 전송
  http.Response response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print('답변 $response');
  // 응답 본문 디코딩
  List<bool> result = json.decode(response.body).cast<bool>();
  print('결과 $result');
  return result;
}
