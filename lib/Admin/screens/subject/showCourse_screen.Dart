import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myproject/Admin/screens/subject/addSubject_screen.dart';
import 'package:myproject/Admin/screens/subject/editSubject_screen.dart';

class Course {
  final String id;
  final String courseCode;
  final String name;
  final int branchIT;
  final int branchCS;

  Course({
    required this.id,
    required this.courseCode,
    required this.name,
    required this.branchIT,
    required this.branchCS,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id_Subjects'] ?? '',
      courseCode: json['courseCode'],
      name: json['name_Subjects'],
      branchIT: json['branchIT'] ?? 0,
      branchCS: json['branchCS'] ?? 0,
    );
  }
}

class ShowCourseScreen extends StatefulWidget {
  @override
  _ShowCourseScreenState createState() => _ShowCourseScreenState();
}

class _ShowCourseScreenState extends State<ShowCourseScreen> {
  late Future<List<Course>> _futureCourses;
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchCourses(); // Initialize in initState
    _searchController.addListener(_filterCourses);
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/subject/showCourse'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<Course> courses = data.map((item) => Course.fromJson(item)).toList();
      setState(() {
        _allCourses = courses;
        _filteredCourses = courses; // Initialize filtered courses
      });
      return courses;
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลวิชาได้');
    }
  }

  void _filterCourses() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        return course.courseCode.toLowerCase().contains(query) ||
               course.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSubjectScreen()),
    );
  }

  void _navigateToEditScreen(String courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSubjectScreen(subjectId: courseId),
      ),
    );
  }

  Future<void> _deleteCourse(String id) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:5000/subject/delete_subject/$id'));

    if (response.statusCode == 200) {
      setState(() {
        _futureCourses = fetchCourses(); // Refresh courses
      });
    } else {
      print('ไม่สามารถลบวิชาได้');
    }
  }

  Future<void> _showConfirmDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบวิชานี้?'),
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
                _deleteCourse(id);
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
        title: Text('รายการวิชาเรียน'),
        backgroundColor: Colors.orange,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('เพิ่มรายวิชา', style: TextStyle(color: Colors.white)),
            onPressed: _navigateToAddScreen,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาด้วยชื่ออหรือรหัสวิชา',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Course>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else {
            return InteractiveViewer(
              boundaryMargin: EdgeInsets.all(8.0),
              minScale: 0.05,
              maxScale: 5.0,
              child: SingleChildScrollView(
                child: Column(
                  children: _filteredCourses.map((course) {
                    String branchDisplay = '';
                    if (course.branchIT == 1 && course.branchCS == 1) {
                      branchDisplay = 'IT,CS';
                    } else if (course.branchIT == 1) {
                      branchDisplay = 'IT';
                    } else if (course.branchCS == 1) {
                      branchDisplay = 'CS';
                    }

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
                                  Text(
                                    branchDisplay,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _navigateToEditScreen(course.id),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showConfirmDialog(course.id),
                                ),
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
