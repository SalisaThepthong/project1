// add_members_screen.dart
import 'package:flutter/material.dart';
import '../controllers/member_controller.dart';
import '../widgets/member_info_widget.dart';

class AddMembersScreen extends StatefulWidget {
  final String username;
  final String prefix;
  final String fname;
  final String lname;
  final String role;
  final String id_User;

  const AddMembersScreen({
    Key? key,
    required this.username,
    required this.prefix,
    required this.fname,
    required this.lname,
    required this.role,
    required this.id_User,
  }) : super(key: key);

  @override
  _AddMembersScreenState createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  late AddMembersController controller;

  @override
  void initState() {
    super.initState();
    controller = AddMembersController();
    controller.initializeMembers(
        widget.prefix, widget.fname, widget.lname, widget.id_User);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลสมาชิก'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              MemberInfoWidget(
                  member: controller.members[0],
                  index: 0,
                  controller: controller),
              ...List.generate(
                controller.members.length - 1,
                (index) => MemberInfoWidget(
                    member: controller.members[index + 1],
                    index: index + 1,
                    controller: controller),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        controller.addMember();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    icon: Icon(Icons.add),
                    label: Text(
                        'เพิ่มสมาชิกคนที่ ${controller.members.length + 1}'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller
                      .validateAndFixUserIds(); // เรียกใช้เมธอดใหม่ก่อนบันทึกข้อมูล
                  controller.saveMembers();
                },
                child: Text('บันทึกข้อมูลสมาชิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
