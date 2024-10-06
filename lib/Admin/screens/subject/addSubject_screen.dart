import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/Admin/validator.dart';

class AddSubjectScreen extends StatefulWidget {
  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedBranch = 'IT';
  int _selectedYear = 2560; // เริ่มต้นที่ปี พ.ศ. 2580 (2560 + 20 ปี)
  List<String> branches = ['IT', 'CS', 'IT & CS'];
  
  Future<void> saveSubject() async {
    final Uri url = Uri.parse("http://10.0.2.2:5000/subject/add_subject");

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
        'yearCourseSub': _selectedYear.toString(),
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ!')),
      );
      _courseCodeController.clear();
      _nameController.clear();
      setState(() {
        _selectedBranch = branches[0];
        _selectedYear = 2580;
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop();
                saveSubject();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectYear(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เลือกปีการศึกษา'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: 20, // แสดงปี พ.ศ. 2560 ถึง 3000
              itemBuilder: (BuildContext context, int index) {
                final int year = 2560 + index;
                return ListTile(
                  title: Text('$year'),
                  onTap: () {
                    setState(() {
                      _selectedYear = year;
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เพิ่มรายวิชา',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
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
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: validateCourseCode,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อวิชา',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: validateName,
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
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () => _selectYear(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'ปีการศึกษา',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${_selectedYear}'),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showSuccessDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('กรุณาตรวจสอบข้อมูลอีกครั้ง')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
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