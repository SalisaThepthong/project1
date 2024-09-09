import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// คลาส Subject สำหรับแปลงข้อมูล JSON
class Subject {
  final String id_Subjects;

  Subject({required this.id_Subjects});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id_Subjects: json['id_Subjects'],
    );
  }
}

class SubjectListScreen extends StatefulWidget {
  @override
  _SubjectListScreenState createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final String baseUrl = 'http://10.0.2.2:5000'; // IP สำหรับ emulator

  // ฟังก์ชันการลบข้อมูล
  Future<void> deleteSubject(String id) async {
    final Uri url = Uri.parse('$baseUrl/delete_subject/$id');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบข้อมูลสำเร็จ')),
      );
      // fetchSubjects(); // อัปเดต UI หรือรีเฟรชข้อมูลหลังจากลบสำเร็จ
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่พบข้อมูลวิชาเรียน')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการลบข้อมูล')),
      );
    }
  }

  // ฟังก์ชันเพื่อแสดงการยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String id) {
    print("Dialog called"); // ตรวจสอบว่าฟังก์ชันนี้ถูกเรียกใช้
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลนี้?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog ถ้าเลือก "ยกเลิก"
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
                deleteSubject(id); // ลบข้อมูลหลังจากการยืนยัน
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันเพื่อดึงข้อมูลวิชา
  Future<List<Subject>> fetchSubjects() async {
    final response = await http.get(Uri.parse('$baseUrl/get_subjects'));
    if (response.statusCode == 200) {
      final List subjects = jsonDecode(response.body);
      return subjects.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลวิชาเรียนได้');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อวิชา'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Subject>>(
        future: fetchSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่มีข้อมูลวิชา'));
          }

          final subjects = snapshot.data!;

          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return Builder(
                builder: (context) {
                  return ListTile(
                    title: Text('ID: ${subject.id_Subjects}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => showDeleteConfirmationDialog(subject.id_Subjects),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
