import 'package:flutter/material.dart';

class ProjectDetailPage extends StatelessWidget {
  final String title;

  const ProjectDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('รายละเอียดของโครงการ: $title'),
      ),
    );
  }
}
