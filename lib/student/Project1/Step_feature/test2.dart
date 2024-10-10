import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myproject/student/Project1/Step_feature/Dropdown.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/subject';

  static Future<List<Map<String, dynamic>>> getSubjects(
      int branchIT, int branchCS, String yearCourseSub) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/subjects_by_branch?branchIT=$branchIT&branchCS=$branchCS&yearCourseSub=$yearCourseSub'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

static Future<List<String>> getBranches() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/subject/branches')); // แก้ไขให้เป็น URL ที่ถูกต้อง
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => item.toString()).toList();
  } else {
    throw Exception('Failed to load branches');
  }
}
}

class SubjectData {
  final Map<String, dynamic> subject;
  String? selectedTerm;
  String? selectedYear;
  String? selectedGrade;

  SubjectData(this.subject);
}

class FeatureStep1 extends StatefulWidget {
  final String prefix;
  final String username;
  final String fname;
  final String lname;
  final String role;

  const FeatureStep1({
    Key? key,
    required this.prefix,
    required this.username,
    required this.fname,
    required this.lname,
    required this.role,
  }) : super(key: key);

  @override
  _FeatureStep1State createState() => _FeatureStep1State();
}

class _FeatureStep1State extends State<FeatureStep1> {
  String? selectedBranch;
  List<SubjectData> subjectDataList = [];
  bool hasSecondMember = false;
  List<String> availableBranches = [];

  String? selectedSemester;
  String? selectedYear;
  TextEditingController studentIdController = TextEditingController();
  
  String? secondMemberPrefix;
  String? secondMemberFirstName;
  String? secondMemberLastName;
  String? secondMemberSemester;
  String? secondMemberYear;
  TextEditingController secondMemberStudentIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

void _loadBranches() async {
  try {
    List<String> branches = await ApiService.getBranches();
    setState(() {
      availableBranches = branches.toSet().toList(); // Remove duplicates
      if (availableBranches.isNotEmpty) {
        selectedBranch = availableBranches[0];
        _loadSubjects();
      }
    });
  } catch (e) {
    print('Error loading branches: $e');
  }
}
  void _loadSubjects() async {
    if (selectedBranch == null) return;

    try {
      final branchParts = selectedBranch!.split(' หลักสูตร ');
      final branch = branchParts[0];
      final year = branchParts[1];

      int branchIT = branch == 'IT' ? 1 : 0;
      int branchCS = branch == 'CS' ? 1 : 0;
      String yearCourseSub = year;

      List<Map<String, dynamic>> allSubjects =
          await ApiService.getSubjects(branchIT, branchCS, yearCourseSub);
      setState(() {
        subjectDataList =
            allSubjects.map((subject) => SubjectData(subject)).toList();
      });
    } catch (e) {
      print('Error loading subjects: $e');
    }
  }

  Widget _buildUserInfo(bool isFirstMember) {
    if (isFirstMember) {
      return Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สมาชิกท่านที่ 1',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, color: const Color.fromARGB(255, 32, 32, 33)),
                SizedBox(width: 10),
                Text('${widget.prefix} ${widget.fname} ${widget.lname}'),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'ภาคการศึกษา',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedSemester,
                    items:
                        ['ภาคต้น', 'ภาคปลาย', 'ภาคฤดูร้อน'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSemester = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'ปีการศึกษา',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedYear,
                    items: List<String>.generate(
                            10,
                            (i) => (DateTime.now().year - 5 + i + 543)
                                .toString())
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedYear = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: studentIdController,
              decoration: const InputDecoration(
                labelText: 'รหัสนักศึกษา',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment_ind, color: Colors.purple),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สมาชิกท่านที่ 2',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'คำนำหน้า',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  secondMemberPrefix = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'ชื่อ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  secondMemberFirstName = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'นามสกุล',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  secondMemberLastName = value;
                });
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'ภาคการศึกษา',
                      border: OutlineInputBorder(),
                    ),
                    value: secondMemberSemester,
                    items: ['ภาคต้น', 'ภาคปลาย', 'ภาคฤดูร้อน']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        secondMemberSemester = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'ปีการศึกษา',
                      border: OutlineInputBorder(),
                    ),
                    value: secondMemberYear,
                    items: List<String>.generate(10, (i) => (DateTime.now().year - 5 + i + 543).toString())
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        secondMemberYear = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: secondMemberStudentIdController,
              decoration: const InputDecoration(
                labelText: 'รหัสนักศึกษา',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment_ind, color: Colors.purple),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('การยื่นแบบตรวจสอบคุณสมบัติ', style: TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 56, 47, 44),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: Container(
      color: Color.fromARGB(255, 252, 248, 227),
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 239, 239),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfo(true), // First member
                      if (hasSecondMember) _buildUserInfo(false), // Second member
                      if (!hasSecondMember)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hasSecondMember = true;
                            });
                          },
                          child: Text('เพิ่มสมาชิกคนที่ 2'),
                        ),
                      SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'เลือกแบบฟอร์มของคุณ',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        value: selectedBranch,
                        items: availableBranches.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedBranch = newValue;
                            _loadSubjects();
                          });
                        }
                      },
                      ),
                      SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('วิชาที่สามารถเลือกได้:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      
                      if (subjectDataList.isNotEmpty)
                        Column(
                          children: subjectDataList.map((subjectData) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: Offset(0, 2)),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${subjectData.subject['courseCode']} ',
                                          style: TextStyle(
                                              color: Colors.red[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        TextSpan(
                                          text: '${subjectData.subject['name_Subjects']}',
                                          style: TextStyle(color: Colors.black, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildDropdown('ภาค', ['ต้น', 'ปลาย', 'ฤดูร้อน'], subjectData.selectedTerm,
                                          (newValue) {
                                        setState(() {
                                          subjectData.selectedTerm = newValue;
                                        });
                                      }),
                                      SizedBox(width: 8),
                                      buildDropdown(
                                          'ปี',
                                          List.generate(8, (index) => (2560 + index).toString()),
                                          subjectData.selectedYear, (newValue) {
                                        setState(() {
                                          subjectData.selectedYear = newValue;
                                        });
                                      }),
                                      SizedBox(width: 8),
                                      buildDropdown(
                                          'เกรด', ['A', 'B', 'B+', 'C', 'C+', 'D', 'D+', 'F'],
                                          subjectData.selectedGrade, (newValue) {
                                        setState(() {
                                          subjectData.selectedGrade = newValue;
                                        });
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('ไม่มีวิชาที่แสดงในขณะนี้', style: TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
} 