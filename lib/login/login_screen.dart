import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myproject/login/register_screen.dart';
import 'package:myproject/login/register_screen.dart';
import 'package:myproject/login/tab_menu_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();
  
  bool loggedIn = false;
  String username = '';

  // void _showSuccessDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('เข้าสู่ระบบสำเร็จ'),
  //         content: const Text('ยินดีต้อนรับ! คุณเข้าสู่ระบบเรียบร้อยแล้ว.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // ปิด dialog
  //             },
  //             child: const Text('ตกลง'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
Future<void> _login() async {
  final url = Uri.parse('http://10.0.2.2:5000/users/login');
  final header = {'Content-Type': 'application/json'};
  
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    _showsnackBar('กรุณากรอกข้อมูลให้ครบถ้วน');
    return;
  }

  final body = jsonEncode({
    'username': _emailController.text,
    'password': _passwordController.text
  });

  try {
    final response = await http.post(url, headers: header, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // ตรวจสอบข้อมูลที่ได้รับ
      if (jsonResponse != null && jsonResponse['user'] != null) {
        final user = jsonResponse['user'];

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TabMenuPage(
              username: user['username'] ?? 'ไม่มีข้อมูล',
              fname: user['fname'] ?? 'ไม่มีข้อมูล',
              lname: user['lname'] ?? 'ไม่มีข้อมูล',
            ),
          ),
        );
      } else {
        _showsnackBar('ข้อมูลผู้ใช้ไม่ถูกต้อง');
      }
    } else {
      _showsnackBar('เข้าสู่ระบบไม่สำเร็จ');
    }
  } catch (e) {
    _showsnackBar('เกิดข้อผิดพลาด: $e');
  }
}



void _showsnackBar(String message) {
 
  final snackbar = SnackBar(
    content: Text(message),duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
  
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // เพิ่มการตรวจสอบแบบเรียลไทม์
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'อีเมล',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกอีเมล';
                    } else if (!value.endsWith('@su.ac.th')) {
                      return 'อีเมลต้องเป็น @su.ac.th';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              //----------------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'รหัสผ่าน',
                    prefixIcon: Icon(Icons.key),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    } else if (value.length < 8) {
                      return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              //----------------------------------------------------------
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // หากการตรวจสอบผ่าน ให้แสดง Dialog
                      //_showSuccessDialog();
                      _login();
                    }
                  },
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ),
              //----------------------------------------------------------
              const SizedBox(height: 2),
              ElevatedButton(
                child: const Text('Register'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
              ),
              //----------------------------------------------------------
              const SizedBox(height: 1),
              TextButton(
                onPressed: () {},
                child: const Text('ลืมรหัสผ่าน', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
