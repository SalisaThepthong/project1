import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myproject/Admin/screens/subject/addSubject_screen.dart';   // นำเข้าหน้าจอ AddSubjectScreen
import 'package:myproject/Admin/screens/subject/editSubject_screen.dart'; // นำเข้าหน้าจอ EditSubjectScreen
//import 'package:myproject/Admin/screens/addSubject_screen.dart';
class Course {
  final String id; // เพิ่ม id สำหรับการลบ
  final String courseCode;
  final String name;
  final int branchIT;
  final int branchCS;

  Course({
    required this.id, // กำหนดค่า id
    required this.courseCode,
    required this.name,
    required this.branchIT,
    required this.branchCS,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id_Subjects'] ?? '', // ดึงค่า id_Subjects
      courseCode: json['courseCode'],
      name: json['name_Subjects'],
      branchIT: json['branchIT'] ?? 0,
      branchCS: json['branchCS'] ?? 0,
    );
  }
}

// สร้างคลาสสําหรับหน้าจอ
class ShowCourseScreen extends StatefulWidget {
  @override
  _ShowCourseScreenState createState() => _ShowCourseScreenState();
}
// สร้างคลาสสําหรับรีเฟรชหน้าจอ
class _ShowCourseScreenState extends State<ShowCourseScreen> {
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000//showCourse')); 
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      //print(data); // พิมพ์ข้อมูลดิบที่ได้รับจาก API
      return data.map((item) => Course.fromJson(item)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลวิชาได้');
    }
  }

  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSubjectScreen()),
    );
  }

void _navigateToEditScreen(String courseCode) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditSubjectScreen(subjectId: courseCode), // แก้เป็นการส่งค่า courseCode ให้ตรงกับที่ต้องการ
    ),
  );
}


 Future<void> _deleteCourse(String id) async {
  final response = await http.delete(Uri.parse('http://10.0.2.2:5000/delete_subject/$id'));

  if (response.statusCode == 200) {
    setState(() {
      fetchCourses(); // รีเฟรชหน้าจอหลังจากลบ
    });
  } else {
    print('ไม่สามารถลบวิชาได้');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการวิชาเรียน'),
        
        backgroundColor: Colors.orange,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('เพิ่มรายวิชา', style: TextStyle(color: Colors.white)),
            onPressed: _navigateToAddScreen,
          ),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else {
            return InteractiveViewer(
              boundaryMargin: EdgeInsets.all(8.0),
              minScale: 0.05,  // ปรับขนาดซูมเข้า
              maxScale: 5.0,  // ปรับขนาดซูมออก
              child: SingleChildScrollView(
                child: Column(
                  children: snapshot.data!.map((course) {
                    //print('courseCode: ${course.courseCode}, name: ${course.name}'); // ตรวจสอบค่าที่ได้รับ
                    // คำนวณการแสดงข้อมูล branch
                    String branchDisplay = '';
                   // print('branchIT: ${course.branchIT}, branchCS: ${course.branchCS}'); // ตรวจสอบค่าที่ได้รับ
                    if (course.branchIT == 1 && course.branchCS == 1) {
                      branchDisplay = 'IT,CS';
                    } else if (course.branchIT == 1) {
                      branchDisplay = 'IT';
                    } else if (course.branchCS == 1) {
                      branchDisplay = 'CS';
                    }

                    // การพิมพ์ข้อมูลเพื่อทดสอบว่า branchDisplay ถูกคำนวณถูกต้องหรือไม่
                    //print('branchDisplay: $branchDisplay');

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.courseCode,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(course.name),
                                  Text(branchDisplay), // แสดงข้อมูล branch
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _navigateToEditScreen(course.id), // ส่ง courseCode เป็นพารามิเตอร์
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: (){ 
                                _deleteCourse("${course.courseCode}");
                                
                              },    
              )

                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}


