// ใน member_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/model_member.dart';
import '../controllers/member_controller.dart';

class MemberService {
  static Future<void> saveMembers(List<Member> members) async {
    // เรียกใช้เมธอดใหม่เพื่อตรวจสอบและแก้ไข id_User ก่อนส่งข้อมูล
    AddMembersController().validateAndFixUserIds();

    final List<Map<String, dynamic>> memberData = members.map((member) {
      return {
        'prefix': member.prefix,
        'first_name': member.firstName,
        'last_name': member.lastName,
        'code_Student': member.studentIdController.text,
        'educationSector': member.selectedSemester,
        'year': int.parse(member.selectedYear!),
        'branch': member.selectedBranch,
        'yearCourse': int.parse(member.selectedCourseYear!),
        'id_User': member.userId,
      };
    }).toList();

    final Map<String, dynamic> payload = {
      'students': memberData,
    };

    print('Payload: ${jsonEncode(payload)}');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/students/add_group_and_student'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      print('บันทึกข้อมูลสมาชิกเรียบร้อยแล้ว!');
    } else {
      print('บันทึกข้อมูลสมาชิกล้มเหลว: ${response.statusCode} - ${response.body}');
    }
  }
}