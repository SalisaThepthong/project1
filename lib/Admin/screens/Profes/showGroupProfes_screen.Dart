import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/Admin/screens/Profes/createGroup_screen.dart';
import 'package:myproject/Admin/screens/Profes/group.dart';
import 'package:myproject/Admin/screens/Profes/group_detail_screen.dart';
import 'package:myproject/Admin/screens/Profes/editGroup_screen.dart';
//หน้าเอาไว้โชว์ข้อมูลอาจารย์ และสมาชิกทั้งหมด
class GroupListScreen extends StatefulWidget {
  final String prefix;
  final String fname;
  final String lname;

  const GroupListScreen({
    Key? key,
    required this.prefix,
    required this.fname,
    required this.lname,
  }) : super(key: key);

  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  List<Group> groups = [];//สร้างตัวแปรเก็บข้อมูลกลุ่ม

  @override
  void initState() {//เรียกใช้งานฟังก์ชันเพื่อโหลดข้อมูลกลุ่ม
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/Profes/groups'));

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

  void _navigateToAddScreen() {//เปิดหน้าสร้างกลุ่ม
    Navigator.push(
      context,
      MaterialPageRoute(//สร้างหน้าสร้างกลุ่ม
        builder: (context) => CreateGroupScreen(//
          prefix: widget.prefix,
          fname: widget.fname,
          lname: widget.lname,
        ),
      ),
    ).then((value) {//ตรวจสอบว่าสร้างกลุ่มสําเร็จหรือไม่
      if (value == true) {
        fetchGroups();
      }
    });
  }

  void _navigateToGroupDetailScreen(Group group) async {//เปิดหน้ารายละเอียดกลุ่ม
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailScreen(group: group),//สร้างหน้ารายละเอียดกลุ่ม
      ),
    );

    if (result == true) {
      fetchGroups();
    }
  }

  void _navigateToEditScreen(String groupId) {//เปิดหน้าแก้ไขกลุ่ม
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGroupScreen(groupId: groupId),    //สร้างหน้าแก้ไขกลุ่ม
      ),
    ).then((value) {
      if (value == true) {
        fetchGroups();
      }
    });
  }

  Future<void> _deleteGroup(String groupId) async {//ลบกลุ่ม
    try {
      final response = await http.delete(Uri.parse('http://10.0.2.2:5000/Profes/delete_group/$groupId'));

      if (response.statusCode == 200) {
        fetchGroups();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กลุ่มถูกลบเรียบร้อยแล้ว')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถลบกลุ่มได้')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการลบกลุ่ม')),
      );
    }
  }

  void _showActionMenu(String groupId) {//แสดงเมนูจัดการกลุ่ม
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
                _navigateToEditScreen(groupId);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('ลบกลุ่ม'),
              onTap: () {
                Navigator.pop(context);
                _showConfirmDialog(groupId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmDialog(String groupId) async {//ยืนยันการลบ
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบกลุ่มนี้?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('ลบ'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteGroup(groupId);
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
                    Icons.group,
                    color: Colors.brown,
                    size: 24.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "กลุ่ม${group.name}",
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                _navigateToGroupDetailScreen(group);
              },
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => _showActionMenu(group.id),
              ),
            ),
          );
        },
      ),
    );
  }
}