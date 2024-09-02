import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddSubjectScreen extends StatefulWidget {
  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedBranch = 'IT'; // ค่าเริ่มต้นของสาขา
  List<String> branches = ['IT', 'CS', 'IT & CS']; // รายการสาขาที่ใช้

  // กำหนดที่อยู่ IP สำหรับ emulator
  final String emulatorIp = 'http://10.0.2.2:5000'; // IP สำหรับ emulator

  Future<void> saveSubject() async {
    final Uri url = Uri.parse("$emulatorIp/add_subject");

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'courseCode': _courseCodeController.text,
        'name_Subjects': _nameController.text,
        'branchIT': _selectedBranch == 'IT' || _selectedBranch == 'IT & CS' ? 1 : 0,
        'branchCS': _selectedBranch == 'CS' || _selectedBranch == 'IT & CS' ? 1 : 0,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกข้อมูลสำเร็จ!')),
      );
      // ล้างข้อมูลในฟอร์ม
      _courseCodeController.clear();
      _nameController.clear();
      setState(() {
        _selectedBranch = branches[0]; // รีเซ็ตค่า Dropdown เป็นค่าเริ่มต้น
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล')),
      );
    }
  }

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
                saveSubject(); // เรียกฟังก์ชันที่ส่งข้อมูลไปยัง API
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
        title: Text(
          'เพิ่มรายวิชา',
          style: TextStyle(color: Colors.white), // สีข้อความใน AppBar
        ),
        centerTitle: true, // ทำให้ข้อความอยู่ตรงกลาง
        backgroundColor: Colors.teal, // สีพื้นหลังของ AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _courseCodeController,
                decoration: InputDecoration(
                  labelText: 'รหัสวิชา',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // ขอบมนของกรอบ
                    borderSide: BorderSide.none, // ไม่ต้องการเส้นขอบ
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200], // สีพื้นหลังของช่องกรอกข้อมูล
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่รหัสวิชา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อวิชา',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // ขอบมนของกรอบ
                    borderSide: BorderSide.none, // ไม่ต้องการเส้นขอบ
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200], // สีพื้นหลังของช่องกรอกข้อมูล
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่ชื่อวิชา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedBranch,
                items: branches.map((String branch) {
                  return DropdownMenuItem<String>(
                    value: branch,
                    child: Text(branch),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBranch = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'สาขา',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // ขอบมนของกรอบ
                    borderSide: BorderSide.none, // ไม่ต้องการเส้นขอบ
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200], // สีพื้นหลังของช่องกรอกข้อมูล
                ),
              ),
              SizedBox(height: 20),
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
    );
  }
}
