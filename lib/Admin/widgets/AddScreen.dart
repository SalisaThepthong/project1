import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Subject'),
        backgroundColor: Colors.orange, // กำหนดสีส้มสำหรับ AppBar ของ AddScreen
      ),
      body: Center(
        child: Text('This is the Add Screen'),
      ),
    );
  }
}
