import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myproject/student/Project1/Step_feature/Dropdown.dart';
//เวอร์ชั่้นที่ 2 ที่มันกดเพิ้มสมาชิกแล้วไปอีกหน้า 
// ... [Previous ApiService and SubjectData classes remain the same] ...

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
  final PageController _pageController = PageController(initialPage: 0);
  List<MemberData> members = [];
  
  @override
  void initState() {
    super.initState();
    members.add(MemberData(
      prefix: widget.prefix,
      firstName: widget.fname,
      lastName: widget.lname,
      isFirstMember: true,
    ));
  }

  void _addSecondMember() {
    setState(() {
      members.add(MemberData(isFirstMember: false));
      _pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
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
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: members.length,
              itemBuilder: (context, index) {
                return MemberPage(
                  memberData: members[index],
                  memberIndex: index + 1,
                );
              },
            ),
          ),
          if (members.length == 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _addSecondMember,
                child: Text('เพิ่มสมาชิกคนที่ 2'),
              ),
            ),
        ],
      ),
    );
  }
}

class MemberData {
  String? prefix;
  String? firstName;
  String? lastName;
  String? semester;
  String? year;
  String? studentId;
  String? selectedBranch;
  List<SubjectData> subjectDataList = [];
  bool isFirstMember;

  MemberData({
    this.prefix,
    this.firstName,
    this.lastName,
    this.isFirstMember = false,
  });
}

class MemberPage extends StatefulWidget {
  final MemberData memberData;
  final int memberIndex;

  const MemberPage({
    Key? key,
    required this.memberData,
    required this.memberIndex,
  }) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final TextEditingController studentIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() async {
    // ... [Implementation of _loadSubjects remains similar to before] ...
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สมาชิกท่านที่ ${widget.memberIndex}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          if (widget.memberData.isFirstMember)
            _buildFirstMemberInfo()
          else
            _buildSecondMemberInfo(),
          SizedBox(height: 16),
          _buildBranchSelection(),
          SizedBox(height: 16),
          _buildSubjectList(),
        ],
      ),
    );
  }

  Widget _buildFirstMemberInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.memberData.prefix} ${widget.memberData.firstName} ${widget.memberData.lastName}'),
            SizedBox(height: 16),
            _buildDropdown('ภาคการศึกษา', ['ภาคต้น', 'ภาคปลาย', 'ภาคฤดูร้อน'], widget.memberData.semester, (value) {
              setState(() => widget.memberData.semester = value);
            }),
            SizedBox(height: 16),
            _buildDropdown('ปีการศึกษา', 
              List.generate(10, (i) => (DateTime.now().year - 5 + i + 543).toString()),
              widget.memberData.year, (value) {
                setState(() => widget.memberData.year = value);
              }
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: studentIdController,
              decoration: InputDecoration(
                labelText: 'รหัสนักศึกษา',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                widget.memberData.studentId = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondMemberInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'คำนำหน้า'),
              onChanged: (value) {
                setState(() => widget.memberData.prefix = value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'ชื่อ'),
              onChanged: (value) {
                setState(() => widget.memberData.firstName = value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'นามสกุล'),
              onChanged: (value) {
                setState(() => widget.memberData.lastName = value);
              },
            ),
            SizedBox(height: 16),
            _buildDropdown('ภาคการศึกษา', ['ภาคต้น', 'ภาคปลาย', 'ภาคฤดูร้อน'], widget.memberData.semester, (value) {
              setState(() => widget.memberData.semester = value);
            }),
            SizedBox(height: 16),
            _buildDropdown('ปีการศึกษา', 
              List.generate(10, (i) => (DateTime.now().year - 5 + i + 543).toString()),
              widget.memberData.year, (value) {
                setState(() => widget.memberData.year = value);
              }
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: studentIdController,
              decoration: InputDecoration(
                labelText: 'รหัสนักศึกษา',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                widget.memberData.studentId = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchSelection() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'เลือกแบบฟอร์มของคุณ',
        border: OutlineInputBorder(),
      ),
      value: widget.memberData.selectedBranch,
      items: ['IT หลักสูตร 60', 'CS หลักสูตร 60', 'IT หลักสูตร 65', 'CS หลักสูตร 65']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          widget.memberData.selectedBranch = newValue;
          _loadSubjects();
        });
      },
    );
  }

  Widget _buildSubjectList() {
    if (widget.memberData.subjectDataList.isEmpty) {
      return Text('ไม่มีวิชาที่แสดงในขณะนี้', style: TextStyle(color: Colors.red));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('วิชาที่สามารถเลือกได้:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ...widget.memberData.subjectDataList.map((subject) => _buildSubjectItem(subject)).toList(),
      ],
    );
  }

  Widget _buildSubjectItem(SubjectData subject) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${subject.subject['courseCode']} ${subject.subject['name_Subjects']}'),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildDropdown('ภาค', ['ต้น', 'ปลาย', 'ฤดูร้อน'], subject.selectedTerm, (value) {
                  setState(() => subject.selectedTerm = value);
                })),
                SizedBox(width: 8),
                Expanded(child: _buildDropdown('ปี', 
                  List.generate(8, (index) => (2560 + index).toString()),
                  subject.selectedYear, (value) {
                    setState(() => subject.selectedYear = value);
                  }
                )),
                SizedBox(width: 8),
                Expanded(child: _buildDropdown('เกรด', ['A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'], subject.selectedGrade, (value) {
                  setState(() => subject.selectedGrade = value);
                })),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}