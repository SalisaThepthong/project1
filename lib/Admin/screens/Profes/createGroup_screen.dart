// นำเข้าไลบรารีต่าง ๆ ที่ใช้ในโปรเจ็กต์
import 'dart:convert'; // ใช้สำหรับแปลงข้อมูลเป็น JSON
import 'package:flutter/material.dart'; // ใช้สำหรับสร้าง UI
import 'package:http/http.dart' as http;


class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final List<Map<String, String?>> _members = []; // รายการเก็บข้อมูลสมาชิก
  final _formKey = GlobalKey<FormState>(); // คีย์สำหรับจัดการฟอร์ม
  final List<String> _prefixOptions = ['นาย','นางสาว','ดร.','อ.','อ.ดร.', 'ผศ.','ผศ.ดร.', 'รศ.', 'รศ.ดร.', 'ศ.','ศ.ดร.'
  ];
  // ตัวเลือกคำนำหน้าชื่อ

  String _groupNumber = ''; // เก็บข้อมูลเลขกลุ่ม
  String _groupName = ''; // เก็บข้อมูลชื่อกลุ่ม

  // ฟังก์ชันเพิ่มสมาชิกใหม่เข้าในกลุ่ม
  void _addMember() {
    setState(() {
      _members.add({
        'prefix': _prefixOptions[0], // คำนำหน้าชื่อเริ่มต้น
        'name': '',
        'lname': '',
        'email': '',
        'facebook': '',
      });
    });
  }

  // ฟังก์ชันส่งข้อมูลฟอร์มไปยัง Backend
  Future<void> _submitData() async {
    // ตรวจสอบการกรอกข้อมูลในฟอร์ม
    if (_formKey.currentState!.validate()) {
      final groupId =
          'G${DateTime.now().millisecondsSinceEpoch}'; // สร้าง ID กลุ่ม
      final groupNumber = _groupNumber;
      final groupName = _groupName;

      final uri = Uri.parse(
          'http://10.0.2.2:5000/add_group_and_members'); // URL ของ API

      // เตรียมข้อมูลเป็น JSON
      final body = jsonEncode({
        'group_number': groupNumber,
        'group_name': groupName,
        'members': _members
            .map((member) => {
                  'member_prefix': member['prefix'] ?? '',
                  'member_name': member['name'] ?? '',
                  'member_lname': member['lname'] ?? '',
                  'member_email': member['email'] ?? '',
                  'member_facebook': member['facebook'] ?? ''
                })
            .toList(),
      });

      // ส่งคำขอ POST ไปยังเซิร์ฟเวอร์
      try {
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 201) {
          // แสดงข้อความเมื่อบันทึกข้อมูลสำเร็จ
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('บันทึกข้อมูลกลุ่มและสมาชิกสำเร็จ!')),
          );
          // เคลียร์ข้อมูลฟอร์ม
          setState(() {
            _groupNumber = '';
            _groupName = '';
            _members.clear();
          });
        } else {
          // แสดงข้อความเมื่อเกิดข้อผิดพลาด
         
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล')),
          );
        }
      } catch (e) {
        // แสดงข้อความเมื่อไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้')),
        );
      }
    }
  }
    //ฟังชั่นสำหรับแสดง Dialog ยืนยันการเพิ่มข้อมูล-------------------------------
  Future<void> showSuccessDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการเพิ่มข้อมูล'),
          content: Text('คุณต้องการเพิ่มข้อมูลนี้ลงในฐานข้อมูลหรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
                _submitData(); // เรียกฟังก์ชันที่ส่งข้อมูลไปยัง API
              },
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
        title: const Text(
          'เพิ่มข้อมูลกลุ่ม',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal, // กำหนดสีของ AppBar
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // กำหนดคีย์ฟอร์ม
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'กรอกชื่อกลุ่มของคุณ', // ข้อความที่คุณต้องการแสดง
                  style: TextStyle(
                    fontSize: 20.0, // ขนาดตัวอักษร
                    fontWeight: FontWeight.bold, // ความหนาของตัวอักษร
                    color: Color.fromARGB(255, 41, 38, 38), // สีของตัวอักษร
                  ),
                ),
                const SizedBox(
                    height: 20.0), // เว้นระยะห่างระหว่างข้อความและฟิลด์กรอก

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey[400]!, width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'ชื่อกลุ่ม',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อกลุ่ม'; // ตรวจสอบว่ากรอกชื่อกลุ่มหรือไม่
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _groupName = value; // เก็บข้อมูลชื่อกลุ่ม
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // ฟิลด์กรอกเลขกลุ่ม
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey[400]!, width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'เลขกลุ่ม',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกเลขกลุ่ม'; // ตรวจสอบว่ากรอกเลขกลุ่มหรือไม่
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _groupNumber = value; // เก็บข้อมูลเลขกลุ่ม
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'เพิ่มสมาชิกกลุ่มของคุณ', // ข้อความที่คุณต้องการแสดง
                  style: TextStyle(
                    fontSize: 20.0, // ขนาดตัวอักษร
                    fontWeight: FontWeight.bold, // ความหนาของตัวอักษร
                    color: Color.fromARGB(255, 41, 38, 38), // สีของตัวอักษร
                  ),
                ),

                const SizedBox(height: 5),
                // รายการสมาชิกของกลุ่ม
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _members.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          border:
                              Border.all(color: Colors.grey[400]!, width: 1.0),
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
                            // ช่องเลือกคำนำหน้าชื่อของสมาชิก
                            DropdownButtonFormField<String>(
                              value: _members[index]['prefix'],
                              items: _prefixOptions.map((prefix) {
                                return DropdownMenuItem<String>(
                                  value: prefix,
                                  child: Text(prefix),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _members[index]['prefix'] =
                                      value; // กำหนดคำนำหน้าชื่อสมาชิก
                                });
                              },
                              decoration: const InputDecoration(
                                  labelText: 'คำนำหน้าชื่อ'),
                            ),
                            const SizedBox(height: 8),
                            // ฟิลด์กรอกชื่อสมาชิก
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'ชื่อ'),
                              onChanged: (value) {
                                _members[index]['name'] =
                                    value; // เก็บข้อมูลชื่อสมาชิก
                              },
                            ),
                            const SizedBox(height: 8),
                            // ฟิลด์กรอกนามสกุลสมาชิก
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'นามสกุล'),
                              onChanged: (value) {
                                _members[index]['lname'] =
                                    value; // เก็บข้อมูลนามสกุลสมาชิก
                              },
                            ),
                            const SizedBox(height: 8),
                            // ฟิลด์กรอกอีเมลสมาชิก
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'อีเมล'),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                _members[index]['email'] =
                                    value; // เก็บข้อมูลอีเมลสมาชิก
                              },
                            ),
                            const SizedBox(height: 8),
                            // ฟิลด์กรอกข้อมูล Facebook ของสมาชิก
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'เฟซบุ๊ก'),
                              onChanged: (value) {
                                _members[index]['facebook'] =
                                    value; // เก็บข้อมูล Facebook ของสมาชิก
                              },
                            ),
                            const SizedBox(height: 8),
                            // ปุ่มลบสมาชิกออกจากกลุ่ม
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // ขนาดของ Row จะเป็นขนาดของเนื้อหา
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _members.removeAt(
                                            index); // ลบสมาชิกออกจากกลุ่ม
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                      width:
                                          2.0), // เว้นระยะห่างระหว่างไอคอนและข้อความ
                                  const Text('ลบสมาชิก'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // ปุ่มเพิ่มสมาชิกใหม่-----------------------------------

                ElevatedButton.icon(
                  onPressed: _addMember, // ฟังก์ชันที่ทำงานเมื่อกดปุ่ม
                  icon: const Icon(Icons.add,
                      color: Colors
                          .black), // ไอคอนรูป add, สีไอคอนเป็นสีดำเพื่อให้ตัดกับพื้นหลัง
                  label: const Text('เพิ่มสมาชิกใหม่  ',
                      style: TextStyle(
                          color: Colors.black)), // ข้อความในปุ่ม, ปรับเป็นสีดำ
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 238, 241, 238)
                        .withOpacity(0.9), // สีพื้นหลังขาวนวลๆ
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // มุมปุ่มโค้งมน
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0), // ระยะห่างแนวตั้งของปุ่ม
                    shadowColor: Colors.grey
                        .withOpacity(0.8), // เพิ่มเงาเบาๆ เพื่อให้ปุ่มโดดเด่น
                  ),
                ),

                const SizedBox(height: 16),
                // ปุ่มบันทึกข้อมูลทั้งหมด-----------------------------------
               ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showSuccessDialog(); // แสดง Dialog สำหรับยืนยันการบันทึก
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('กรุณาตรวจสอบข้อมูลอีกครั้ง')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // สีของปุ่ม
                  minimumSize: Size(double.infinity, 50), // ความยาวของปุ่ม
                ),
                child: Text('Finish'),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
