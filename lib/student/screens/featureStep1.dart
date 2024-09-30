import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeatureStep1(),
    );
  }
}

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:5000/subject/subjects_by_branch';

  static Future<List<Map<String, dynamic>>> getSubjects(
      int branchIT, int branchCS, String yearCourseSub) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?branchIT=$branchIT&branchCS=$branchCS&yearCourseSub=$yearCourseSub'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }
}

class FeatureStep1 extends StatefulWidget {
  @override
  _FeatureStep1State createState() => _FeatureStep1State();
}

class _FeatureStep1State extends State<FeatureStep1> {
  String? selectedBranch = 'IT หลักสูตร 60';
  List<Map<String, dynamic>> subjects = [];
  String? selectedTerm; // สำหรับเก็บภาคเรียน
  String? selectedYear; // สำหรับเก็บปีการศึกษา
  String? selectedGrade; // สำหรับเก็บเกรด

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() async {
    try {
      int branchIT = 0;
      int branchCS = 0;
      String yearCourseSub = '2560';

      if (selectedBranch == 'IT หลักสูตร 60') {
        branchIT = 1;
      } else if (selectedBranch == 'CS หลักสูตร 60') {
        branchCS = 1;
      } else if (selectedBranch == 'IT หลักสูตร 65') {
        branchIT = 1;
        yearCourseSub = '2565';
      } else if (selectedBranch == 'CS หลักสูตร 65') {
        branchCS = 1;
        yearCourseSub = '2565';
      }

      List<Map<String, dynamic>> allSubjects =
          await ApiService.getSubjects(branchIT, branchCS, yearCourseSub);
      setState(() {
        subjects = allSubjects;
      });
    } catch (e) {
      print('Error loading subjects: $e');
    }
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        value: selectedValue,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การยื่นแบบตรวจสอบคุณสมบัติ',
            style: TextStyle(color: Colors.white)), // ตั้งค่าสีข้อความ
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // สำหรับการจัดแนวแนวตั้ง
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // วงกลมซ้อนอยู่ข้างใต้
                          Container(
                            width: 60, // ขนาดวงกลม
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(
                                  255, 3, 107, 29), // สีของวงกลม
                            ),
                          ),
                          Text(
                            'Step 1',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: 18,
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255), // สีข้อความ
                                ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16), // เว้นระยะห่างระหว่างวงกลมและข้อความ
                      const Expanded(
                        child: Text(
                          'การยื่นแบบตรวจสอบคุณสมบัติในการมีสิทธิ์ขอจัดทำโครงงาน (CS00G/IT00G)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 230, 227, 227), // สีพื้นหลัง
                        borderRadius: BorderRadius.circular(15), // ทำให้ขอบโค้ง
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dropdown สำหรับเลือกแบบฟอร์ม
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'เลือกแบบฟอร์มของคุณ',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: const Color.fromARGB(255, 255, 255, 255), // ใช้สีของ Dropdown ที่แตกต่างจากสีของ Container
                              ),
                              value: selectedBranch,
                              items: [
                                'IT หลักสูตร 60',
                                'CS หลักสูตร 60',
                                'IT หลักสูตร 65',
                                'CS หลักสูตร 65'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedBranch = newValue;
                                  _loadSubjects();
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            // แสดงรายการวิชาในรูปแบบ List
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('วิชาที่สามารถเลือกได้:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                            if (subjects.isNotEmpty)
                              Column(
                                children: subjects.map((subject) {
                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(
                                          15), // ทำให้ขอบโค้ง
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: Offset(0, 2)),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${subject['courseCode']} ',
                                                style: TextStyle(
                                                    color: Colors.red[800],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${subject['name_Subjects']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        // Row สำหรับ Dropdowns
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildDropdown(
                                                'ภาค',
                                                ['ต้น', 'ปลาย', 'ฤดูร้อน'],
                                                selectedTerm, (newValue) {
                                              setState(() {
                                                selectedTerm = newValue;
                                              });
                                            }),
                                            SizedBox(width: 8), // เว้นระยะห่าง
                                            _buildDropdown(
                                                'ปี',
                                                List.generate(
                                                    8,
                                                    (index) => (2560 + index)
                                                        .toString()),
                                                selectedYear, (newValue) {
                                              setState(() {
                                                selectedYear = newValue;
                                              });
                                            }),
                                            SizedBox(width: 8), // เว้นระยะห่าง
                                            _buildDropdown(
                                                'เกรด',
                                                [
                                                  'A',
                                                  'B',
                                                  'B+',
                                                  'C',
                                                  'C+',
                                                  'D',
                                                  'D+',
                                                  'F'
                                                ],
                                                selectedGrade, (newValue) {
                                              setState(() {
                                                selectedGrade = newValue;
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
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('ไม่มีวิชาที่แสดงในขณะนี้',
                                    style: TextStyle(color: Colors.red)),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
