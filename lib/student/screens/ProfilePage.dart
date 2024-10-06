import 'package:flutter/material.dart';
import 'CustomBottomNavigationBar.dart'; // นำเข้าไฟล์ใหม่

class ProfilePage extends StatelessWidget {
  final String prefix;
  final String username;
  final String fname;
  final String lname;
  final String role;
  final String id_User;
  //final String id_group_project;

  final int selectedIndex;
  final Function(int) onItemTapped;

  const ProfilePage({
    super.key,
    required this.prefix,
    required this.username,
    required this.fname,
    required this.lname,
    required this.role,
    required this.id_User,
    //required this.id_group_project,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  // ฟังก์ชันสำหรับล็อกเอาต์
  void _logout(BuildContext context) {
    // เพิ่มการนำทางไปยังหน้าเข้าสู่ระบบที่คุณต้องการที่นี่
    Navigator.of(context).pushReplacementNamed('/login'); // เปลี่ยน '/login' ตามเส้นทางของหน้าเข้าสู่ระบบของคุณ
  }

  @override
  Widget _buildUserInfo() {
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
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ข้อมูลผู้ใช้',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.person, color: Colors.blue),
              SizedBox(width: 10),
              Text('$prefix $fname $lname'),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.email, color: Colors.green),
              SizedBox(width: 10),
              Text(username),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.work, color: Colors.orange),
              SizedBox(width: 10),
              Text(role),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
        backgroundColor: const Color.fromARGB(255, 56, 47, 44),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
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
              _buildUserInfo(),  // เรียกใช้ฟังก์ชันใหม่ที่สร้างขึ้น
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
       // id_group_project: id_group_project ,
        //selectedIndex: selectedIndex,

      ),
    );
  }
}
