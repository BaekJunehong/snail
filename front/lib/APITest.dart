import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart' as xml2json;
import 'dart:convert';

class OpenApiExample extends StatelessWidget {
  final word = '나무';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Open API Example"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  var url = Uri.http(
                      'ec2-43-202-125-41.ap-northeast-2.compute.amazonaws.com:3000',
                      '/KoreanAPI');
                  try {
                    var response = await http.post(url, body: {'word': word});
                    print(response.statusCode);
                    if (response.statusCode == 200) {
                      final xml2json.Xml2Json xml2Json = xml2json.Xml2Json();
                      xml2Json.parse(response.body);
                      var jsonData = xml2Json.toParker();

                      var decodedData = jsonDecode(jsonData);
                      var total = decodedData['channel']['total'];
                      print('Total: $total');
                    } else {
                      print('API 요청이 실패했습니다.');
                    }
                  } catch (e) {
                    print('API 요청 중 오류 발생: $e');
                  }
                },
                child: Text("Open API 불러오기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(OpenApiExample());
