import 'package:flutter/material.dart';
import 'CustomBottomNavigationBar.dart'; // นำเข้าไฟล์ใหม่

class ProfilePage extends StatelessWidget {
  final String prefix;
  final String username;
  final String fname;
  final String lname;
  final String role;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const ProfilePage({
    super.key,
    required this.prefix,
    required this.username,
    required this.fname,
    required this.lname,
    required this.role,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  // ฟังก์ชันสำหรับล็อกเอาต์
  void _logout(BuildContext context) {
    // เพิ่มการนำทางไปยังหน้าเข้าสู่ระบบที่คุณต้องการที่นี่
    Navigator.of(context).pushReplacementNamed('/login'); // เปลี่ยน '/login' ตามเส้นทางของหน้าเข้าสู่ระบบของคุณ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
        backgroundColor: const Color.fromARGB(255, 56, 47, 44),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // ไอคอนล็อกเอาต์
            onPressed: () => _logout(context), // เรียกใช้ฟังก์ชันล็อกเอาต์เมื่อคลิก
          ),
        ],
      ),
      body: 
      Container(
          color: Color.fromARGB(255, 252, 248, 227),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email, size: 30, color: Color.fromARGB(255, 217, 110, 103)),
                      const SizedBox(width: 10),
                      Text(
                        'อีเมล: $username',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 30, color: Color.fromARGB(255, 131, 198, 133)),
                      const SizedBox(width: 10),
                      Text(
                        'ชื่อ: $prefix $fname $lname',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.star_outline_sharp, size: 30, color: Color.fromARGB(255, 55, 145, 173)),
                      const SizedBox(width: 10),
                      Text(
                        'สถานะ: $role',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 300.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemSelected: onItemTapped,
        username: username,
        prefix: prefix,
        fname: fname,
        lname: lname,
        role: role,
      ),
    );
  }
}
