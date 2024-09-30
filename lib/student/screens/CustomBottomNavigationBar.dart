import 'package:flutter/material.dart';
import 'ProfilePage.dart'; // นำเข้า ProfilePage
import 'homeStudent.dart'; // นำเข้า HomeStudent

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String username;
  final String prefix;
  final String fname;
  final String lname;
  final String role;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.username,
    required this.prefix,
    required this.fname,
    required this.lname,
    required this.role,
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
              selectedIndex: index,
              onItemTapped: onItemSelected,
            ),
          ));
        } else if (index == 1) {
          // เมื่อคลิกแท็บ "Home"
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeStudent(
              username: username,
              prefix: prefix,
              fname: fname,
              lname: lname,
              role: role,
              //selectedIndex: index,
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
