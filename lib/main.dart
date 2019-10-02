import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as client;

Future<News> fetchNews() async {
  var _apiKey ='d641f36aa8b7450cb3ebe7fbc1e69917';
  final response = await client.get(
      'https://newsapi.org/v2/top-headlines?country=id&apiKey='+_apiKey);
  if (response.statusCode == 200) {
    print(response.body);
    return News.fromJson(json.decode(response.body));
  } else {
    throw Exception('failed to load');
  }
}

class News {
  final List articles;
  News({this.articles});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(articles: json['articles']);
  }
}

void main() {
  runApp(MyApp(
    news: fetchNews(),
  ));
}

class MyApp extends StatelessWidget {
  Future<News> news;
  MyApp({Key key, @required this.news}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch news',
      home: Scaffold(
        appBar: AppBar(
          title: Text('News Fetch'),
        ),
        body: FutureBuilder<News>(
          future: news,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.articles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data.articles[index]['title']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
