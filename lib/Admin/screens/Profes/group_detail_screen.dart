import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/Admin/screens/Profes/group.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({Key? key, required this.group}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {

  Future<void> _deleteMember(String id_Member) async {
    try {
      final response = await http.delete(Uri.parse('http://10.0.2.2:5000/Profes/delete_member/$id_Member'));

      if (response.statusCode == 200) {
        setState(() {
          widget.group.members.removeWhere((member) => member.id == id_Member);
        });
      } else {
        print('ไม่สามารถลบสมาชิกได้: ${response.statusCode}');
        print('รายละเอียดการตอบกลับ: ${response.body}');
      }
    } catch (e) {
      print('ข้อผิดพลาดในการลบสมาชิก: $e');
    }
  }

//ลบสมาชิก
  Future<void> _showConfirmMemberDialog(BuildContext context, String groupId, String memberId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบสมาชิก'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบสมาชิกนี้?'),
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
                _deleteMember(memberId);
              },
            ),
          ],
        );
      },
    );
  }

  void _showActionMenu(BuildContext context, String groupId, String memberId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('ลบสมาชิก'),
              onTap: () {
                Navigator.pop(context);
                _showConfirmMemberDialog(context, groupId, memberId);
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
                onPressed: () => _showActionMenu(context, widget.group.id, member.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
