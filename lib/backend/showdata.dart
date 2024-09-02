import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('รายชื่อจากฐานข้อมูล'),
        ),
        body: DataScreen(),
      ),
    );
  }
}

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<String> _names = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/data'));


    if (response.statusCode == 200) {
      setState(() {
        _names = List<String>.from(jsonDecode(response.body));
          // พิมพ์ข้อมูล JSON ที่ได้รับจาก API ลงใน console
    print('Data fetched from API: ${response.body}');
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _names.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_names[index]),
        );
      },
    );
  }
}
