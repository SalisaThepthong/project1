import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditGroupScreen extends StatefulWidget {
  final String groupId;
  const EditGroupScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final TextEditingController groupNumberController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();

  final List<String> _prefixOptions = [
    'นาย',
    'นางสาว',
    'ดร.',
    'อ.',
    'อ.ดร.',
    'ผศ.',
    'ผศ.ดร.',
    'รศ.',
    'รศ.ดร.',
    'ศ.',
    'ศ.ดร.'
  ];

  List<Map<String, dynamic>> memberControllers = [];

  @override
  void initState() {
    super.initState();
    fetchGroupDetails(widget.groupId); // Fetch group details when screen is initialized
  }

  Future<void> fetchGroupDetails(String groupId) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/Profes/group_and_members/$groupId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched Data: $data');

        final groupNumber = data['group_Number'].toString();
        final groupName = data['group_Name'] as String;

        setState(() {
          groupNumberController.text = groupNumber;
          groupNameController.text = groupName;

          // Initialize member controllers
          memberControllers = data['members'].map<Map<String, dynamic>>((member) {
            return {
              'id_Member': TextEditingController(text: member['id_Member']),
              'prefix': member['prefix'],
              'first_name': TextEditingController(text: member['first_name']),
              'last_name': TextEditingController(text: member['last_name']),
              'email': TextEditingController(text: member['email']),
              'facebook': TextEditingController(text: member['facebook']),
            };
          }).toList();
        });
      } else {
        print('Failed to fetch group details: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch group details')),
        );
      }
    } catch (e) {
      print('Error fetching group details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching group details')),
      );
    }
  }

  Future<void> updateGroup() async {
  try {
    final membersData = memberControllers.map((memberController) {
      return {
        'id_Member': memberController['id_Member']!.text,
        'prefix': memberController['prefix'],
        'first_name': memberController['first_name']!.text,
        'last_name': memberController['last_name']!.text,
        'email': memberController['email']!.text,
        'facebook': memberController['facebook']!.text,
      };
    }).toList();

    final response = await http.put(
      Uri.parse('http://10.0.2.2:5000/Profes/group_and_members/${widget.groupId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'group_Number': groupNumberController.text,
        'group_Name': groupNameController.text,
        'members': membersData,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group and members updated successfully')),
      );
      // กลับไปยังหน้าก่อนหน้า และ refresh ข้อมูลที่อัปเดต
      Navigator.of(context).pop(true); // ส่งค่ากลับไปหน้าก่อนหน้าหลังจากอัปเดตสำเร็จ
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update group and members')),
      );
    }
  } catch (e) {
    print('Error updating group and members: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating group and members')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แก้ไขข้อมูลกลุ่ม',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStyledTextField(groupNumberController, 'Group Number'),
              _buildStyledTextField(groupNameController, 'Group Name'),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: memberControllers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildStyledDropdownButton(index),
                      _buildStyledTextField(memberControllers[index]['first_name'], 'First Name'),
                      _buildStyledTextField(memberControllers[index]['last_name'], 'Last Name'),
                      _buildStyledTextField(memberControllers[index]['email'], 'Email'),
                      _buildStyledTextField(memberControllers[index]['facebook'], 'Facebook'),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_validateForm()) {
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

  Widget _buildStyledTextField(TextEditingController controller, String labelText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
          ),
        ),
      ),
    );
  }

  Widget _buildStyledDropdownButton(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: memberControllers[index]['prefix'],
        onChanged: (String? newValue) {
          setState(() {
            memberControllers[index]['prefix'] = newValue!;
          });
        },
        items: _prefixOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        underline: SizedBox(),
        hint: Text('Select Prefix'),
      ),
    );
  }

  bool _validateForm() {
    for (var controller in memberControllers) {
      if (controller['first_name']!.text.isEmpty ||
          controller['last_name']!.text.isEmpty ||
          controller['email']!.text.isEmpty ||
          controller['facebook']!.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<void> showSuccessDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการแก้ไขข้อมูล'),
          content: Text('คุณต้องการแก้ไขข้อมูลนี้หรือไม่?'),
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
                updateGroup();
              },
            ),
          ],
        );
      },
    );
  }
}
