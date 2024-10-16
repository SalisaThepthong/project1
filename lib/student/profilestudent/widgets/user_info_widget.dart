import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final String prefix;
  final String username;
  final String fname;
  final String lname;
  final String role;

  const UserInfoWidget({
    Key? key,
    required this.prefix,
    required this.username,
    required this.fname,
    required this.lname,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}