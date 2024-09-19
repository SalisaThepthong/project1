import 'package:flutter/material.dart';

class TabMenuPage extends StatefulWidget {
  final String username;
  final String fname;
  final String lname;

  const TabMenuPage({
    super.key, 
    required this.username, 
    required this.fname, 
    required this.lname
  });

  @override
  State<TabMenuPage> createState() => _TabMenuPageState();
}

class _TabMenuPageState extends State<TabMenuPage> {
  late String _username;
  late String _fname;
  late String _lname;
   
  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _fname = widget.fname;
    _lname = widget.lname;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('หน้าหลัก'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Project1'),
              Tab(text: 'Project2'),
              Tab(text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [ 
            const Center(child: Text('Project1')), 
            const Center(child: Text('Project2')), 
            
            // แสดงข้อมูลในแท็บ Profile
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                        Row(
                          children: [
                            Icon(Icons.person, size: 30, color: Colors.blue),
                            const SizedBox(width: 10),
                            Text(
                              'Username: $_username',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 30, color: Colors.green),
                            const SizedBox(width: 10),
                            Text(
                              'First Name: $_fname',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 30, color: Colors.red),
                            const SizedBox(width: 10),
                            Text(
                              'Last Name: $_lname',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
