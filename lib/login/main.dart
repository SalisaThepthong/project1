import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart'; // ตรวจสอบให้แน่ใจว่ามีไฟล์นี้อยู่
import 'my_home_screen.dart'; 
import 'package:myproject/Admin/screens/homeAdmin_screen.dart';
import 'package:myproject/teacher/screens/HomeTeacher_Screen.dart';
import 'package:myproject/student/screens/HomeStudent_Screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 249, 252, 233),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 68, 62, 62)),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 107, 103, 101), // สีของ AppBar
    foregroundColor: Colors.white, // สีของข้อความใน AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 107, 103, 101), // สีปุ่มที่ต้องการ
      foregroundColor: Colors.white, // สีตัวอักษรบนปุ่ม
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 27, 94, 32), // สีของ TextButton
    ),
  ),
),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomeScreen(), // เพิ่มหน้าหลักที่ต้องการ
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MyHomeScreen(), // กำหนดเส้นทางไปยังหน้าหลัก
        '/homeAdmin': (context) => HomeScreen(),
        '/homeTeacher': (context) => HomeTeacherScreen(),
        '/homeStudent': (context) => HomeStudentScreen(),
      },
    );
  }
}