import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Maitree Font',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Maitree', // ชื่อฟอนต์ที่ตั้งค่าไว้ใน pubspec.yaml
      ),
      home: FontTestScreen(),
    );
  }
}

class FontTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ทดสอบฟอนต์ Maitree',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500, // น้ำหนักของฟอนต์
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'สวัสดี Maitree Font!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500, // น้ำหนักของฟอนต์
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is another line of text.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
