import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/Admin/screens/Profes/createGroup_screen.dart';
import 'package:myproject/Admin/screens/Profes/group.dart';
import 'package:myproject/Admin/screens/Profes/group_detail_screen.dart';
import 'package:myproject/Admin/screens/Profes/editGroup_screen.dart';
//import 'group_detail_screen.dart'; // import ไฟล์ที่แยกไว้

class GroupListScreen extends StatefulWidget {
  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  List<Group> groups = [];

  Future<void> fetchGroups() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/groups'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          groups = data.map((groupJson) => Group.fromJson(groupJson)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load groups')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateGroupScreen()),
    );
  }
// ไปหน้าจอ GroupDetailScreen
  void _navigateToGroupDetailScreen(Group group) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailScreen(group: group),
      ),
    );
  

    // รีเฟรชกลุ่มเมื่อกลับมาพร้อมผลการลบสำเร็จ
    if (result == true) {
      fetchGroups();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลอาจารย์'),
        backgroundColor: Colors.orange,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('สร้างกลุ่ม', style: TextStyle(color: Colors.white)),
            onPressed: _navigateToAddScreen,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
     child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.group, // ใช้ไอคอนที่คุณต้องการ
                      color: Colors.brown, // สีของไอคอน
                      size: 24.0, // ขนาดของไอคอน
                    ),
                    SizedBox(width: 10),
                  Text(
                     "กลุ่ม${group.name}",
                    //group.name,
                    style: TextStyle(
                      color: Colors.brown,
                      //fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    
                    ),
                  ),
                  // SizedBox(width: 10),
                  // Text(
                  //   "กลุ่ม 0${group.members.length.toString()}",
                  //  //group.members.length.toString(),
                  //   style: TextStyle(
                  //    // fontWeight: FontWeight.bold,
                  //     fontSize: 20.0,
                  //   ),
                  // ),
                ],
              ),
              // trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
              onTap: () {
                _navigateToGroupDetailScreen(group);
              },
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () =>  _showActionMenu(context, group.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showActionMenu(BuildContext context, String groupId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('แก้ไขกลุ่ม'),
              onTap: () {
                Navigator.pop(context);
                _navigateToEditScreen(context,groupId);
                // Add your navigation to the edit screen here
              //EditGroupScreen(context, groupId);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('ลบกลุ่ม'),
              onTap: () {
                Navigator.pop(context);
                _showConfirmDialog(context, groupId);
              },
            ),
          ],
        );
      },
    );
  }
  void _navigateToEditScreen(BuildContext context, String groupId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditGroupScreen(groupId: groupId), // แก้เป็นการส่งค่า courseCode ให้ตรงกับที่ต้องการ
    ),
  );
}

  
    Future<void> _deleteGroup(BuildContext context, String groupId) async {
  try {
    final response =
        await http.delete(Uri.parse('http://10.0.2.2:5000/delete_group/$groupId'));

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // ใช้ context ที่ถูกส่งมาจากฟังก์ชัน
    } else {
      print('ไม่สามารถลบกลุ่มได้: ${response.statusCode}');
      print('รายละเอียดการตอบกลับ: ${response.body}');
    }
  } catch (e) {
    print('ข้อผิดพลาดในการลบกลุ่ม: $e');
  }
}

    Future<void> _showConfirmDialog(BuildContext context, String groupId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ยืนยันการลบ'),
        content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบกลุ่มนี้?'),
        actions: <Widget>[
          TextButton(
            child: Text('ยกเลิก'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('ลบ'),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteGroup(context, groupId); // ส่ง context ไปยังฟังก์ชัน
            },
          ),
        ],
      );
    },
  );
}
