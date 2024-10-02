import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/Admin/validator.dart';
//หน้าสำหรับสร้างกลุ่ม

class CreateGroupScreen extends StatefulWidget {
  final String prefix;
  final String fname;
  final String lname;
  
  const CreateGroupScreen({
    Key? key,
    required this.prefix,
    required this.fname,
    required this.lname,
  }) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final List<Map<String, dynamic>> _members = [];
  final _formKey = GlobalKey<FormState>();
  String _groupNumber = '';
  String _groupName = '';
  List<Map<String, String>> _teacherOptions = [];

  late String _prefix;
  late String _fname;
  late String _lname;

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
    _prefix = widget.prefix;
    _fname = widget.fname;
    _lname = widget.lname;
  }

  Future<void> _fetchTeachers() async {
    final uri = Uri.parse('http://10.0.2.2:5000/users/get_teachers');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _teacherOptions = data.map((teacher) {
            return {
              'prefix': teacher['prefix'] as String,
              'first_name': teacher['first_name'] as String,
              'last_name': teacher['last_name'] as String
            };
          }).toList();
        });
      } else {
        print('Failed to fetch teachers');
      }
    } catch (e) {
      print('Error fetching teachers: $e');
    }
  }

  void _addMember() {
    setState(() {
      _members.add({
        'teacher': null,
        'prefix': '',
        'name': '',
        'lname': '',
        'email': '',
        'facebook': '',
      });
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final uri = Uri.parse('http://10.0.2.2:5000/Profes/add_group_and_members');

      final body = jsonEncode({
        'group_number': _groupNumber,
        'group_name': _groupName,
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

      try {
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('บันทึกข้อมูลกลุ่มและสมาชิกสำเร็จ!')),
          );
          setState(() {
            _groupNumber = '';
            _groupName = '';
            _members.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้')),
        );
      }
    }
  }

  Future<void> showSuccessDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการเพิ่มข้อมูล'),
          content: const Text('คุณต้องการเพิ่มข้อมูลนี้ลงในฐานข้อมูลหรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitData();
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
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'กรอกชื่อกลุ่มของคุณ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 41, 38, 38),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ชื่อกลุ่ม'),
                  validator: validateName,
                  onChanged: (value) {
                    _groupName = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'เลขกลุ่ม'),
                  keyboardType: TextInputType.number,
                  validator: validateCourseCode,
                  onChanged: (value) {
                    _groupNumber = value;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'เพิ่มสมาชิกกลุ่มของคุณ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 41, 38, 38),
                  ),
                ),
                const SizedBox(height: 5),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _members.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey[300]!, width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 242, 240, 237).withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         DropdownButtonFormField<Map<String, String>>(
                  value: (_members[index]['teacher'] as Map<String, String>?) ?? null,
                  items: _teacherOptions.map((Map<String, String> teacher) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: teacher,
                      child: Text('${teacher['prefix']} ${teacher['first_name']} ${teacher['last_name']}'),
                    );
                  }).toList(),
                  onChanged: (Map<String, String>? value) {
                    setState(() {
                      _members[index]['teacher'] = value;
                      _members[index]['prefix'] = value?['prefix'] ?? '';
                      _members[index]['name'] = value?['first_name'] ?? '';
                      _members[index]['lname'] = value?['last_name'] ?? '';
                    });
                  },
                              decoration: const InputDecoration(
                                labelText: 'เลือกอาจารย์',
                                border: InputBorder.none,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'อีเมล'),
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                              onChanged: (value) {
                                _members[index]['email'] = value;
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Facebook'),
                              onChanged: (value) {
                                _members[index]['facebook'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _addMember,
                    child: const Text('เพิ่มสมาชิกกลุ่ม'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: showSuccessDialog,
                    child: const Text('บันทึกข้อมูลกลุ่มและสมาชิก'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}