import 'package:flutter/material.dart';
import 'package:myproject/login/login_screen.dart';

import 'package:myproject/login/register_screen.dart'; // ตรวจสอบให้แน่ใจว่ามีไฟล์นี้อยู่
//import 'package:myproject/login/my_home_screen.dart'; 
import 'package:myproject/Admin/screens/homeAdmin_screen.dart';
import 'package:myproject/teacher/screens/HomeTeacher_Screen.dart';
// import 'package:myproject/student/screens/HomeStudent_Screen.dart';
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
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 252, 169, 35)),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 252, 169, 35), // สีของ AppBar
    foregroundColor: Colors.white, // สีของข้อความใน AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 252, 169, 35), // สีปุ่มที่ต้องการ
      foregroundColor: Colors.white, // สีตัวอักษรบนปุ่ม
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 27, 94, 32), // สีของ TextButton
    ),
  ),
),
      initialRoute: '/login',
      routes: {
       // '/': (context) => const MyHomeScreen(), // เพิ่มหน้าหลักที่ต้องการ
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        //'/main': (context) => const MyHomeScreen(), // กำหนดเส้นทางไปยังหน้าหลัก
        //'/homeAdmin': (context) => HomeScreen(),
        '/homeTeacher': (context) => HomeTeacherScreen(),
        //'/homeStudent': (context) => HomeStudentScreen(),
      },
    );
  }
}