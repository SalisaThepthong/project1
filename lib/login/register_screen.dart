import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myproject/lib/login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  // กำหนดตัวควบคุมสำหรับ input fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedPrefix = 'นาย'; // ค่าเริ่มต้นสำหรับคำนำหน้าชื่อ
  String _selectedRole = 'นักศึกษา'; // ค่าเริ่มต้นสำหรับ Dropdown บทบาท

  final _formKey = GlobalKey<FormState>();

  Future<void> registration() async {
    // แสดง SnackBar ขณะกำลังลงทะเบียน
    showProcessingSnackBar();

    // ตรวจสอบ validation
    if (_formKey.currentState!.validate()) {
      final url = 'http://10.0.2.2:5000/users/register'; // URL ของ API ที่คุณสร้าง
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prefix': _selectedPrefix,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'role': _selectedRole,
        }),
      );

      // ตรวจสอบผลลัพธ์จาก API
      if (response.statusCode == 201) {
        // หากสำเร็จ แสดง Success SnackBar และกลับไปที่หน้า Login
        showSuccessSnackBar();
        //Future.delayed(const Duration(seconds: 3), () {
        //  Navigator.pushReplacementNamed(context, '/login');
        // });
      } else {
        print('เกิดข้อผิดพลาด: ${response.body}');
        // กรณีเกิดข้อผิดพลาด แสดงข้อความ error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${response.body}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Prefix Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedPrefix,
                    decoration: const InputDecoration(
                      labelText: 'เลือกคำนำหน้าชื่อ',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    items: ['นาย', 'นางสาว', 'นาง', 'ดร.', 'อ.', 'อ.ดร.', 'ผศ.', 'ผศ.ดร.', 'รศ.', 'รศ.ดร.', 'ศ.', 'ศ.ดร.']
                        .map((prefix) => DropdownMenuItem<String>(
                              value: prefix,
                              child: Text(prefix),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPrefix = newValue!;
                      });
                    },
                  ),
                ),
                // First Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _firstNameController,
                    validator: (value) {
                      return _validateRegisterInput(value, 'ชื่อ', 1, 50);
                    },
                    decoration: const InputDecoration(
                      labelText: 'ชื่อ',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Last Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _lastNameController,
                    validator: (value) {
                      return _validateRegisterInput(value, 'นามสกุล', 1, 50);
                    },
                    decoration: const InputDecoration(
                      labelText: 'นามสกุล',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกอีเมล';
                      }
                      if (!value.endsWith('@su.ac.th')) {
                        return 'กรุณากรอกอีเมลที่ลงท้ายด้วย @su.ac.th';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: _validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Confirm Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    validator: _validateConfirmPassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Role Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'เลือกบทบาท',
                      prefixIcon: Icon(Icons.group),
                      border: OutlineInputBorder(),
                    ),
                    items: ['แอดมิน', 'อาจารย์', 'นักศึกษา']
                        .map((role) => DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: registration,
                        child: const Text('ตกลง'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: resetInput,
                        child: const Text('ยกเลิก'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => gotoLogin(context),
                    child: const Text(
                      'มีบัญชีอยู่แล้ว ไปยังหน้าล็อคอิน',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetInput() {
    _formKey.currentState!.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void showProcessingSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('กำลังสร้างบัญชี'),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('สร้างบัญชีสำเร็จ'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'ไปยังหน้าหลัก',
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
    );
  }

  void gotoLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  String? _validateRegisterInput(String? value, String label, int min, int max) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกข้อมูล $label';
    } else if (value.length < min || value.length > max) {
      return 'กรอก $label ความยาว $min ถึง $max อักขระ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    } else if (value.length < 8) {
      return 'รหัสผ่านต้องมีอย่างน้อย 8 อักขระ';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'รหัสผ่านไม่ตรงกัน';
    }
    return null;
  }
}
