import 'package:flutter/material.dart';

// หน้า HomeTeacherScreen
class HomeTeacherScreen extends StatefulWidget {
  const HomeTeacherScreen({super.key});

  @override
  State<HomeTeacherScreen> createState() => _HomeTeacherScreentState();
}

class _HomeTeacherScreentState extends State<HomeTeacherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลักสำหรับอาจารย์'),
      ),
      body: const Center(
        child: Text('ยินดีต้อนรับ, อาจารย์!'),
      ),
    );
  }
}