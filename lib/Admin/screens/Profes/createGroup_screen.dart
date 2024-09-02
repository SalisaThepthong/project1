import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final List<Map<String, String>> _members = [];
  final _formKey = GlobalKey<FormState>();
  File? _groupImage;
  final ImagePicker _picker = ImagePicker();

  void _addMember() {
    setState(() {
      _members.add({
        'name': '',
        'email': '',
        'facebook': '',
        'position': '',
      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _groupImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _groupImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มข้อมูลกลุ่ม',
          style: TextStyle(color: Colors.white), // สีข้อความใน AppBar
        ),
        centerTitle: true, // ทำให้ข้อความอยู่ตรงกลาง
        backgroundColor: Colors.teal, // สีพื้นหลังของ AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อกลุ่ม
                TextFormField(
                  decoration: InputDecoration(labelText: 'ชื่อกลุ่ม'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อกลุ่ม';
                    }
                    return null;
                  },
                ),
                // เลขกลุ่ม
                TextFormField(
                  decoration: InputDecoration(labelText: 'เลขกลุ่ม'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกเลขกลุ่ม';
                    }
                    return null;
                  },
                ),
                // รูปกลุ่ม
                SizedBox(height: 16),
                _groupImage == null
                    ? Text('กรุณาเลือกหรือถ่ายรูปกลุ่ม')
                    : Image.file(
                        _groupImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('เลือกจากแกลเลอรี'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _takePhoto,
                      child: Text('ถ่ายรูปใหม่'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // สมาชิกกลุ่ม
                for (int i = 0; i < _members.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'ชื่อสมาชิก'),
                        onChanged: (value) {
                          setState(() {
                            _members[i]['name'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อสมาชิก';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'อีเมล'),
                        onChanged: (value) {
                          setState(() {
                            _members[i]['email'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกอีเมล';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Facebook'),
                        onChanged: (value) {
                          setState(() {
                            _members[i]['facebook'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอก Facebook';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Position'),
                        onChanged: (value) {
                          setState(() {
                            _members[i]['position'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกตำแหน่ง';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                // ปุ่มเพิ่มสมาชิกใหม่
                ElevatedButton(
                  onPressed: _addMember,
                  child: Text('เพิ่มสมาชิกใหม่'),
                ),
                // ปุ่มยืนยัน
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // โค้ดสำหรับส่งข้อมูลไปยัง server หรือ database
                    }
                  },
                  child: Text('ยืนยัน'),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   // ... (โค้ดสำหรับ bottom navigation bar)
      // ),
    );
  }
}
