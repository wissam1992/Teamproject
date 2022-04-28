import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

Future<String> getData() async {
  http.Response response = await http.get(
      Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
      headers: {"Accept": "application/json"});

  List data = json.decode(response.body);
  print(data[1]["title"]);
}

/*
Future<http.Response> updateData(String title) {
  return http.put(
    'https://jsonplaceholder.typicode.com/albums/1',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>){
      'title': title,
    }),
    );
}
*/