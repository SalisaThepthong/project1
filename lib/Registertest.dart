import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
   final __firstNameController = TextEditingController();
  final __lastNameController = TextEditingController();
  final __emailController = TextEditingController();
  final __passwordController = TextEditingController();
  final __confirmPasswordController = TextEditingController();
  final __roleController = TextEditingController();
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _role = 'นักศึกษา'; // ตั้งค่าเริ่มต้นเป็นนักศึกษา

  // ฟังก์ชันตรวจสอบอีเมล su.ac.th
  String? _validateEmail(String value) {
    if (!value.endsWith('@su.ac.th')) {
      return 'ต้องใช้อีเมลที่ลงท้ายด้วย @su.ac.th';
    }
    return null;
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // ตรวจสอบบทบาทและนำทางไปยังหน้าที่ต้องการ
      if (_role == 'แอดมิน') {
        Navigator.pushNamed(context, '/homeAdmin');
      } else if (_role == 'อาจารย์') {
        Navigator.pushNamed(context, '/homeTeacher');
      } else if (_role == 'นักศึกษา') {
        Navigator.pushNamed(context, '/homeStudent');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลงทะเบียน'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'ชื่อ'),
                onSaved: (value) {
                  _firstName = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'นามสกุล'),
                onSaved: (value) {
                  _lastName = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณากรอกนามสกุล';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'อีเมล'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  _email = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณากรอกอีเมล';
                  }
                  return _validateEmail(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'รหัสผ่าน'),
                obscureText: true,
                onSaved: (value) {
                  _password = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  }
                  if (value.length < 6) {
                    return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ยืนยันรหัสผ่าน'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณายืนยันรหัสผ่าน';
                  }
                  if (value != _password) {
                    return 'รหัสผ่านไม่ตรงกัน';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'เลือกบทบาท'),
                value: _role,
                items: ['แอดมิน', 'อาจารย์', 'นักศึกษา']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _register,
                child: Text('ลงทะเบียน'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
