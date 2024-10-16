import 'package:flutter/material.dart';
import 'package:myproject/student/custom_bottomn_avigationbar_student.dart';
import '../controllers/home_student_controller.dart';
import '../widgets/step_button.dart';


class HomeStudentScreen extends StatelessWidget {
  final String username;
  final String prefix;
  final String fname;
  final String lname;
  final String role;
  final String id_User;

  HomeStudentScreen({
    Key? key,
    required this.username,
    required this.prefix,
    required this.fname,
    required this.lname,
    required this.role,
    required this.id_User,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = HomeStudentController();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('รายการที่ต้องดำเนินการ'),
          backgroundColor: const Color.fromARGB(255, 56, 47, 44),
          elevation: 0,
        ),
        body: Container(
          color: Color.fromARGB(255, 252, 248, 227),
          constraints: const BoxConstraints.expand(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'โปรเจค 1',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  StepButton(
                    title: 'ตรวจสอบคุณสมบัติ\nและขอจัดสรรกลุ่ม',
                    step: 1,
                    isActive: true,
                    onPressed: () => controller.navigateToAddMembers(context, username, prefix, fname, lname, role, id_User),
                  ),
                  StepButton(title: 'คำร้องขอเสนอ\nหัวข้อโครงงาน', step: 2, isActive: false),
                  StepButton(title: 'Proposal', step: 3, isActive: false),
                  SizedBox(height: 20),
                  const Text(
                    'โปรเจค 2',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  StepButton(title: 'Midway', step: 1, isActive: false),
                  StepButton(title: 'Final', step: 2, isActive: false),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: 1,
          onItemSelected: (index) {},
          username: username,
          prefix: prefix,
          fname: fname,
          lname: lname,
          role: role,
          id_User: id_User,
        ),
      ),
    );
  }
}