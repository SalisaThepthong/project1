import 'package:flutter/material.dart';
import '../models/model_member.dart';
import '../services/member_service.dart';

class AddMembersController {
  List<Member> members = [];
  final List<String> prefixes = ['นาย', 'นาง', 'นางสาว'];
  final List<String> semesters = ['ภาคต้น', 'ภาคปลาย', 'ภาคฤดูร้อน'];
  final List<String> years = List<String>.generate(10, (index) => (2560 + index).toString());
  final List<String> branches = ['IT', 'CS'];
   late String currentUserId;  // เพิ่มตัวแปรเก็บ id ของผู้ใช้ปัจจุบัน
  void initializeMembers(String prefix, String fname, String lname, String id_User) {
    currentUserId = id_User;  // เก็บ id ของผู้ใช้ปัจจุบัน
    members.add(Member(
      prefix: prefix,
      firstName: fname,
      lastName: lname,
      userId: id_User,
      isFirstMember: true,
      selectedSemester: semesters[0],
      selectedYear: years[0],
      selectedBranch: branches[0],
      selectedCourseYear: years[0],
    ));
  }

  void addMember() {
    members.add(Member(
      prefix: prefixes[0],
      firstName: '',
      lastName: '',
      userId: currentUserId,  // ใช้ id ของผู้ใช้ปัจจุบันสำหรับสมาชิกใหม่ทุกคน
      isFirstMember: false,
      selectedSemester: semesters[0],
      selectedYear: years[0],
      selectedBranch: branches[0],
      selectedCourseYear: years[0],
    ));
  }

  void removeMember(int index) {
    members.removeAt(index);
  }

  Future<void> saveMembers() async {
    for (var member in members) {
      if (member.studentIdController.text.isEmpty || 
          member.selectedSemester == null || 
          member.selectedYear == null ||
          member.selectedBranch == null ||
          member.selectedCourseYear == null) {
        print('กรุณากรอกข้อมูลในฟิลด์ที่จำเป็นสำหรับแต่ละสมาชิก');
        return;
      }
    }

    await MemberService.saveMembers(members);
  }
    // เพิ่มเมธอดใหม่เพื่อตรวจสอบและแก้ไข id_User ที่เป็นค่าว่าง
  void validateAndFixUserIds() {
    for (var member in members) {
      if (member.userId.isEmpty) {
        member.userId = currentUserId;
      }
    }
  }

}