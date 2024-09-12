import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/Admin/screens/Profes/createGroup_screen.dart';
import 'package:myproject/Admin/screens/Profes/group.dart';

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
              title: Text(
                group.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
              onTap: () {
                _navigateToGroupDetailScreen(group);
              },
            ),
          );
        },
      ),
    );
  }
}

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({Key? key, required this.group}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  Future<void> _deleteGroup(String groupId) async {
    try {
      final response =
          await http.delete(Uri.parse('http://10.0.2.2:5000/delete_group/$groupId'));

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // ส่งค่า true กลับไปเพื่อบอกว่าลบสำเร็จ
      } else {
        print('ไม่สามารถลบกลุ่มได้: ${response.statusCode}');
        print('รายละเอียดการตอบกลับ: ${response.body}');
      }
    } catch (e) {
      print('ข้อผิดพลาดในการลบกลุ่ม: $e');
    }
  }

  Future<void> _showConfirmDialog(BuildContext context, String id_Group) async {
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
                _deleteGroup(id_Group);
              },
            ),
          ],
        );
      },
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // Add your navigation to the edit screen here
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _showConfirmDialog(context, widget.group.id);
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
        title: Text(widget.group.name),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.delete, color: Colors.red),
            label: Text('ลบกลุ่ม', style: TextStyle(color: Colors.white)),
            onPressed: () {
              _showConfirmDialog(context, widget.group.id);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.group.members.length,
        itemBuilder: (context, index) {
          final member = widget.group.members[index];
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
              title: Text(
                '${member.prefix}${member.name} ${member.lastName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.red),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          member.email,
                          style: TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  if (member.facebook.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.facebook, color: Colors.blue),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            member.facebook,
                            style: TextStyle(color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => _showActionMenu(context),
              ),
            ),
          );
        },
      ),
    );
  }
}
