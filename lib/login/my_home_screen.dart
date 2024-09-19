// my_home_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart'; // ตรวจสอบให้แน่ใจว่าคุณได้ทำการนำเข้า

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: const Text('Welcome to the Home Screen!'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.login_rounded),
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // ใช้ pushNamed แทน
              },
            ),
            IconButton(
              icon: const Icon(Icons.app_registration_rounded),
              onPressed: () {
                Navigator.pushNamed(context, '/register'); // ใช้ pushNamed แทน
              },
            ),
          ],
        ),
      ),
    );
  }
}
