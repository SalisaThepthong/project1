import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubjectListScreen extends StatefulWidget {
  @override
  _SubjectListScreenState createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final String baseUrl = 'http://10.0.2.2:5000'; // IP สำหรับ emulator

  Future<void> deleteSubject(String id) async {
    final Uri url = Uri.parse('$baseUrl/delete_subject/$id');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบข้อมูลสำเร็จ!')),
      );
      // อัปเดต UI หรือรีเฟรชข้อมูลหลังจากลบสำเร็จ
      fetchSubjects();
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

  Future<List<Subject>> fetchSubjects() async {
    final response = await http.get(Uri.parse('$baseUrl/get_subjects'));
    if (response.statusCode == 200) {
      final List subjects = jsonDecode(response.body);
      return subjects.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการวิชาเรียน'),
      ),
      body: FutureBuilder<List<Subject>>(
        future: fetchSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่มีข้อมูล'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final subject = snapshot.data![index];
                return ListTile(
                  title: Text(subject.name_Subjects),
                  subtitle: Text('รหัสวิชา: ${subject.id_Subjects}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteSubject(subject.id_Subjects); // เรียกใช้ deleteSubject พร้อมส่ง id_Subjects
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// คลาส Subject สำหรับแปลงข้อมูล JSON
class Subject {
  final String id_Subjects;
  final String name_Subjects;

  Subject({required this.id_Subjects, required this.name_Subjects});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id_Subjects: json['id_Subjects'],
      name_Subjects: json['name_Subjects'],
    );
  }
}
