import 'package:flutter/material.dart';

void main() {
  runApp(const LoginScreen());
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late bool loggedIn;
  late String username;

  @override
  void initState() {
    super.initState();
    loggedIn = false;
    username = '';
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เข้าสู่ระบบสำเร็จ'),
          content: const Text('ยินดีต้อนรับ! คุณเข้าสู่ระบบเรียบร้อยแล้ว.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
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
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // หากการตรวจสอบผ่าน ให้แสดง Dialog
                      _showSuccessDialog();
                    }
                  },
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ),
              //----------------------------------------------------------
              const SizedBox(height: 2),
              TextButton(
                onPressed: () {},
                child: const Text('ลงทะเบียน', style: TextStyle(color: Colors.redAccent)),
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
