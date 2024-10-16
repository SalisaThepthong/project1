// import 'package:flutter/material.dart';
// import 'package:myproject/student/custom_bottomn_avigationbar_student.dart'; // นำเข้าไฟล์ใหม่
// import '../Project1/Step_feature/Step1_addGroupAndStudent/screens/add_members_screen.dart'; // นำเข้าไฟล์ใหม่สำหรับหน้า ProjectDetail

// class HomeStudent extends StatefulWidget {
//   final String username;
//   final String prefix;
//   final String fname;
//   final String lname;
//   final String role;
//   final String id_User; 
//   //final String id_group_project;
  
//   const HomeStudent({
//     super.key,
//     required this.username,
//     required this.prefix,
//     required this.fname,
//     required this.lname,
//     required this.role,
//     required this.id_User,
//    // required this.id_group_project,
//   });

//   @override
//   State<HomeStudent> createState() => _HomeStudentState();
// }

// class _HomeStudentState extends State<HomeStudent> {
//   late String _username;
//   late String _prefix;
//   late String _fname;
//   late String _lname;
//   late String _role;
//   late String _id_User;
//  // late String _id_group_project;
//   int _selectedIndex = 1;

//   @override
//   void initState() {
//     super.initState();
//     _username = widget.username;
//     _prefix = widget.prefix;
//     _fname = widget.fname;
//     _lname = widget.lname;
//     _role = widget.role;
//     _id_User = widget.id_User;
//     //_id_group_project = widget.id_group_project;
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Widget _buildStepButton(String title, int step, bool isActive) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: isActive ? Colors.green : Colors.grey,
//             ),
//             child: Center(
//               child: Text(
//                 '$step',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: isActive
//                   ? () {
//                       // นำทางไปยังหน้ารายละเอียดโครงการ
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddMembersScreen(
                            
//                             username: _username,
//                             prefix: _prefix,
//                             fname: _fname,
//                             lname: _lname,
//                            role: _role,
//                            id_User:_id_User,
//                           //id_group_project: _id_group_project,
//                           ), // ส่งชื่อโครงการไปยังหน้าใหม่
//                         ),
//                       );
//                     }
//                   : null,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(title),
//                     Icon(Icons.arrow_forward_ios, size: 16),
//                   ],
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.black,
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false, // ปิดการกลับหน้าด้วยปุ่มย้อนกลับ
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('รายการที่ต้องดำเนินการ'),
//           backgroundColor: const Color.fromARGB(255, 56, 47, 44),
//           elevation: 0,
          
          
//         ),
//         body: Container(
//           color: Color.fromARGB(255, 252, 248, 227),
//           constraints: const BoxConstraints.expand(), // ครอบคลุมพื้นที่เต็มจอ
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'โปรเจค 1',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   _buildStepButton('ตรวจสอบคุณสมบัติ\nและขอจัดสรรกลุ่ม', 1, true),
//                   _buildStepButton('คำร้องขอเสนอ\nหัวข้อโครงงาน', 2, false),
//                   _buildStepButton('Proposal', 3, false),
//                   SizedBox(height: 20),
//                   const Text(
//                     'โปรเจค 2',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   _buildStepButton('Midway', 1, false),
//                   _buildStepButton('Final', 2, false),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: CustomBottomNavigationBar(
//           selectedIndex: _selectedIndex,
//           onItemSelected: _onItemTapped,
//           username: _username,
//           prefix: _prefix,
//           fname: _fname,
//           lname: _lname,
//           role: _role,
//           id_User: _id_User,
         
//         ),
//       ),
//     );
//   }
// }