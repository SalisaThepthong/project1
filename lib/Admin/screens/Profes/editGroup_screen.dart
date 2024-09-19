import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myproject/Admin/validator.dart';
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
    fetchGroupDetails(widget.groupId); // Call the method to fetch group details
  }

  Future<void> fetchGroupDetails(String groupId) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/Profes/group_and_members/$groupId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched Data: $data'); // Debug print to check the fetched data

        final groupNumber = data['group_Number'].toString();
        final groupName = data['group_Name'] as String;

        setState(() {
          groupNumberController.text = groupNumber;
          groupNameController.text = groupName;

          // Initialize member controllers
          memberControllers = data['members'].map<Map<String, dynamic>>((member) {
            return {
              'id_Member': TextEditingController(text: member['id_Member']),
              'member_Prefix': member['member_Prefix'],
              'member_Name': TextEditingController(text: member['member_Name']),
              'member_Lname': TextEditingController(text: member['member_Lname']),
              'member_Email': TextEditingController(text: member['member_Email']),
              'member_Facebook': TextEditingController(text: member['member_Facebook']),
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
        'member_Prefix': memberController['member_Prefix'],
        'member_Name': memberController['member_Name']!.text,
        'member_Lname': memberController['member_Lname']!.text,
        'member_Email': memberController['member_Email']!.text,
        'member_Facebook': memberController['member_Facebook']!.text,
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
      setState(() {
        // Optional: Update state or refresh UI if needed
        fetchGroupDetails(widget.groupId); // Refresh data
      });
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
        backgroundColor: Colors.teal, // กำหนดสีของ AppBar
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
                      _buildStyledTextField(memberControllers[index]['member_Name'], 'Member Name'),
                      _buildStyledTextField(memberControllers[index]['member_Lname'], 'Member Last Name'),
                      _buildStyledTextField(memberControllers[index]['member_Email'], 'Member Email'),
                      _buildStyledTextField(memberControllers[index]['member_Facebook'], 'Member Facebook'),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_validateForm()) {
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
        value: memberControllers[index]['member_Prefix'],
        onChanged: (String? newValue) {
          setState(() {
            memberControllers[index]['member_Prefix'] = newValue!;
          });
        },
        items: _prefixOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        underline: SizedBox(), // Remove the default underline
        hint: Text('Select Prefix'),
      ),
    );
  }

  // ฟังก์ชันสำหรับการตรวจสอบความถูกต้องของข้อมูล
  bool _validateForm() {
    for (var controller in memberControllers) {
      if (controller['member_Name']!.text.isEmpty ||
          controller['member_Lname']!.text.isEmpty ||
          controller['member_Email']!.text.isEmpty ||
          controller['member_Facebook']!.text.isEmpty) {
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
                Navigator.of(context).pop(); // ปิด Dialog
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
                updateGroup(); // เรียกฟังก์ชันที่ส่งข้อมูลไปยัง API
              },
            ),
          ],
        );
      },
    );
  }
}
