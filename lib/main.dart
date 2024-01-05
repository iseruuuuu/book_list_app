import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List items = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var response = await http.get(
      Uri.https(
        'www.googleapis.com',
        '/books/v1/volumes',
        {
          'q': '{Flutter}',
          'maxResults': '40',
          'langRestrict': 'ja',
        },
      ),
    );
    var jsonResponse = jsonDecode(response.body);

    setState(() {
      items = jsonResponse['items'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  leading: Image.network(
                      items[index]['volumeInfo']['imageLinks']['thumbnail']),
                  title: Text(items[index]['volumeInfo']['title']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
