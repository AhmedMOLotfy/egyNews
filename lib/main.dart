import 'dart:async';
import 'dart:convert';
import 'package:egynews/News.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<List<News>> fetchAlbum() async {
  final response =
      await http.get("http://newsapi.org/v2/top-headlines?country=eg"
          "&apiKey=03b9c7bd2661483fbc3cd590d65fc255#");
  List<News> list;
  if (response.statusCode == 200) {
    var parsed = jsonDecode(response.body);
    var results = parsed["articles"];
    list = results.map<News>((a) => News.fromJson(a)).toList();
    return list;
  } else {
    throw Exception('Failed to load album');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<News>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          centerTitle: true,
          title: Text(' مصر'),
        ),
        body: Center(
          child: FutureBuilder<List<News>>(
            future: fetchAlbum(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data.map((e) => _buildItem(e)).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildItem(News news) {
  return Column(
    children: [
      Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(news.urlToImage),
              ExpansionTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    news.title,
                    style: TextStyle(),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, right: 20, left: 6),
                        child: Text(
                          news.description.toString(),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.launch,
                            ),
                            onPressed: () {
                              launch(news.url);
                            },
                          ),
                          Text(news.source.values.elementAt(1).toString())
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Divider(
        height: 0,
      ),
    ],
  );
}
//"articles": [
// {
// "source": {
// "id": null,
// "name": "Youm7.com"
// },
// "author": null,
// "title": "أول تعليق من أروى جودة على مشهد "ده هانى" من مسلسل هذا المساء - اليوم السابع",
// "description": "تصدر مشهد النجمة أروى جودة مع محمد سليمان في مسلسل "هذا المساء" الذى تم طرحه موسم رمضان عام 2017 مواقع التواصل الاجتماعى.",
// "url": "https://www.youm7.com/story/2021/1/4/أول-تعليق-من-أروى-جودة-على-مشهد-ده-هانى-من/5143404",
// "urlToImage": "https://img.youm7.com/large/202003310727462746.jpg",
// "publishedAt": "2021-01-04T19:21:00Z",
// "content": null
