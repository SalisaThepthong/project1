// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'models/model_memder.dart';

// class AddMembers extends StatefulWidget {
//   final String username;
//   final String prefix;
//   final String fname;
//   final String lname;
//   final String role;
//   final String id_User;

//   const AddMembers({
//     Key? key,
//     required this.username,
//     required this.prefix,
//     required this.fname,
//     required this.lname,
//     required this.role,
//     required this.id_User,
//   }) : super(key: key);

//   @override
//   _AddMembersState createState() => _AddMembersState();
// }

// class _AddMembersState extends State<AddMembers> {
//   List<Member> members = [];
//   final List<String> prefixes = ['นาย', 'นาง', 'นางสาว'];
//   final List<String> semesters = ['ภาคต้น', 'ภาคปลาย', 'ภาคฤดูร้อน'];
//   final List<String> years = List<String>.generate(10, (index) => (2560 + index).toString());
//   final List<String> branches = ['IT', 'CS'];

//   @override
//   void initState() {
//     super.initState();
//     members.add(Member(
//       prefix: widget.prefix,
//       firstName: widget.fname,
//       lastName: widget.lname,
//       userId: widget.id_User,
//       isFirstMember: true,
//       selectedSemester: semesters[0],
//       selectedYear: years[0],
//       selectedBranch: branches[0],
//       selectedCourseYear: years[0],
//     ));
//   }

//   void addMember() {
//     setState(() {
//       members.add(Member(
//         prefix: prefixes[0],
//         firstName: '',
//         lastName: '',
//         userId: '',
//         isFirstMember: false,
//         selectedSemester: semesters[0],
//         selectedYear: years[0],
//         selectedBranch: branches[0],
//         selectedCourseYear: years[0],
//       ));
//     });
//   }

//   void removeMember(int index) {
//     setState(() {
//       members.removeAt(index);
//     });
//   }

//   Future<void> saveMembers() async {
//     for (var member in members) {
//       if (member.studentIdController.text.isEmpty || 
//           member.selectedSemester == null || 
//           member.selectedYear == null ||
//           member.selectedBranch == null ||
//           member.selectedCourseYear == null) {
//         print('กรุณากรอกข้อมูลในฟิลด์ที่จำเป็นสำหรับแต่ละสมาชิก');
//         return;
//       }
//     }

//     final List<Map<String, dynamic>> memberData = members.map((member) {
//       return {
//         'prefix': member.prefix,
//         'first_name': member.firstName,
//         'last_name': member.lastName,
//         'code_Student': member.studentIdController.text,
//         'educationSector': member.selectedSemester,
//         'year': int.parse(member.selectedYear!),
//         'branch': member.selectedBranch,
//         'yearCourse': int.parse(member.selectedCourseYear!),
//         'id_User': member.isFirstMember ? widget.id_User : null, //
//       };
//     }).toList();

//     final Map<String, dynamic> payload = {
//       'students': memberData,
//     };

//     print('Payload: ${jsonEncode(payload)}');

//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:5000/students/add_group_and_student'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode == 201) {
//       print('บันทึกข้อมูลสมาชิกเรียบร้อยแล้ว!');
//     } else {
//       print('บันทึกข้อมูลสมาชิกล้มเหลว: ${response.statusCode} - ${response.body}');
//     }
//   }

//   Widget _buildMemberInfo(int index) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       margin: EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'สมาชิกท่านที่ ${index + 1}',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           if (index == 0)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.person, color: Colors.purple),
//                     SizedBox(width: 10),
//                     Text('${widget.prefix} ${widget.fname} ${widget.lname}'),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Text('ข้อมูลจาก User ที่ login'),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   initialValue: widget.prefix,
//                   decoration: InputDecoration(labelText: 'คำนำหน้า', border: OutlineInputBorder()),
//                   onChanged: (value) {
//                     setState(() {
//                       members[index].prefix = value;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   initialValue: widget.fname,
//                   decoration: InputDecoration(labelText: 'ชื่อ', border: OutlineInputBorder()),
//                   onChanged: (value) {
//                     setState(() {
//                       members[index].firstName = value;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   initialValue: widget.lname,
//                   decoration: InputDecoration(labelText: 'นามสกุล', border: OutlineInputBorder()),
//                   onChanged: (value) {
//                     setState(() {
//                       members[index].lastName = value;
//                     });
//                   },
//                 ),
//               ],
//             )
//           else
//             Column(
//               children: [
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(labelText: 'คำนำหน้า', border: OutlineInputBorder()),
//                    value: members[index].prefix ?? prefixes[0],
//                   items: prefixes.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       members[index].prefix = newValue;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'ชื่อ', border: OutlineInputBorder()),
//                   onChanged: (value) {
//                     setState(() {
//                       members[index].firstName = value;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'นามสกุล', border: OutlineInputBorder()),
//                   onChanged: (value) {
//                     setState(() {
//                       members[index].lastName = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           SizedBox(height: 15),

//           TextFormField(
//             controller: members[index].studentIdController,
//             decoration: const InputDecoration(
//               labelText: 'รหัสนักศึกษา',
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.assignment_ind, color: Colors.purple),
//             ),
//             keyboardType: TextInputType.number,
//           ),
//           SizedBox(height: 10),

//           Row(
//             children: [
//               Icon(Icons.warning, color: Color.fromARGB(255, 236, 163, 45)),
//               SizedBox(width: 8),
//               Text(
//                 'ภาคการศึกษาและปีการศึกษา ในปัจจุบัน',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     labelText: 'ภาคการศึกษา',
//                     border: OutlineInputBorder(),
//                   ),
//                   value: members[index].selectedSemester ?? semesters[0],
//                   items: semesters.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       members[index].selectedSemester = newValue;
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     labelText: 'ปีการศึกษา',
//                     border: OutlineInputBorder(),
//                   ),
//                   value: members[index].selectedYear ?? years[0],
//                   items: years.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       members[index].selectedYear = newValue;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),

//           DropdownButtonFormField<String>(
//             decoration: const InputDecoration(
//               labelText: 'สาขา',
//               border: OutlineInputBorder(),
//             ),
//             value: members[index].selectedBranch ?? branches[0],
//             items: branches.map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 members[index].selectedBranch = newValue;
//               });
//             },
//           ),
//           SizedBox(height: 10),

//           DropdownButtonFormField<String>(
//             decoration: const InputDecoration(
//               labelText: 'ปีหลักสูตรที่เรียน',
//               border: OutlineInputBorder(),
//             ),
//             value: members[index].selectedCourseYear ?? years[0],
//             items: years.map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 members[index].selectedCourseYear = newValue;
//               });
//             },
//           ),

//           if (index != 0)
//             Align(
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                 icon: Icon(Icons.delete, color: Colors.red),
//                 onPressed: () => removeMember(index),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('เพิ่มข้อมูลสมาชิก'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _buildMemberInfo(0),
//               ...List.generate(
//                   members.length - 1,
//                   (index) => _buildMemberInfo(index + 1)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: addMember,
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: Colors.black,
//                     ),
//                     icon: Icon(Icons.add),
//                     label: Text('เพิ่มสมาชิกคนที่ ${members.length + 1}'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: saveMembers,
//                 child: Text('บันทึกข้อมูลสมาชิก'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }