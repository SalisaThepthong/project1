import 'package:flutter/material.dart';
import 'package:myproject/student/custom_bottomn_avigationbar_student.dart';
import '../widgets/user_info_widget.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final String prefix;
  final String username;
  final String fname;
  final String lname;
  final String role;
  final String id_User;
  final int selectedIndex;
  final Function(int) onItemTapped;

  ProfileScreen({
    Key? key,
    required this.prefix,
    required this.username,
    required this.fname,
    required this.lname,
    required this.role,
    required this.id_User,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  final ProfileController _controller = ProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
        backgroundColor: const Color.fromARGB(255, 56, 47, 44),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _controller.logout(context),
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 252, 248, 227),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoWidget(
                prefix: prefix,
                fname: fname,
                lname: lname,
                username: username,
                role: role,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 300.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemSelected: onItemTapped,
        username: username,
        prefix: prefix,
        fname: fname,
        lname: lname,
        role: role,
        id_User: id_User,
      ),
    );
  }
}