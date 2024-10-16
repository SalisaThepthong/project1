import 'package:flutter/material.dart';
import 'package:myproject/student/homestudent/screens/home_student_screen.dart';
import 'screens/ProfilePage.dart'; // นำเข้า ProfilePage

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String username;
  final String prefix;
  final String fname;
  final String lname;
  final String role;
  final String id_User;
  //final String id_group_project;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.username,
    required this.prefix,
    required this.fname,
    required this.lname,
    required this.role,
    required this.id_User,
    //required this.id_group_project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 2) {
          // เมื่อคลิกแท็บ "Me"
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(
              username: username,
              prefix: prefix,
              fname: fname,
              lname: lname,
              role: role,
              id_User: id_User,
              selectedIndex: index,
              onItemTapped: onItemSelected,
            ),
          ));
        } else if (index == 1) {
          // เมื่อคลิกแท็บ "Home"
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeStudentScreen(
              username: username,
              prefix: prefix,
              fname: fname,
              lname: lname,
              role: role,
              id_User: id_User,
            ), // เปลี่ยนไปยัง HomeStudent
          ));
        } else {
          onItemSelected(index); // สำหรับแท็บอื่นๆ
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Content',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Me',
        ),
      ],
    );
  }
}
