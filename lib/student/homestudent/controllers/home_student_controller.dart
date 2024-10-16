import 'package:flutter/material.dart';
import 'package:myproject/student/Project1/Step_feature/Step1_addGroupAndStudent/screens/add_members_screen.dart'; // นำเข้าไฟล์ใหม่สำหรับหน้า ProjectDetail

class HomeStudentController {
  void navigateToAddMembers(BuildContext context, String username, String prefix, String fname, String lname, String role, String id_User) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMembersScreen(
          username: username,
          prefix: prefix,
          fname: fname,
          lname: lname,
          role: role,
          id_User: id_User,
        ),
      ),
    );
  }
}