import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/Admin/validator.dart';

class EditSubjectScreen extends StatefulWidget {
  final String subjectId;

  EditSubjectScreen({required this.subjectId});

  @override
  _EditSubjectScreenState createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedBranch = 'IT'; // Default branch
  List<String> branches = ['IT', 'CS', 'IT & CS']; // Branch list

  @override
  void initState() {
    super.initState();
    _fetchSubjectDetails(); // Fetch subject details on initialization
  }

  Future<void> _fetchSubjectDetails() async {
    final Uri url = Uri.parse("http://10.0.2.2:5000/subject/updatesubject/${widget.subjectId}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _courseCodeController.text = data['courseCode'] ?? '';
        _nameController.text = data['name_Subjects'] ?? '';
        _selectedBranch = data['branchIT'] == 1
            ? 'IT'
            : (data['branchCS'] == 1
                ? 'CS'
                : 'IT & CS');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch subject details: ${response.reasonPhrase}')),
      );
    }
  }

  Future<void> _updateSubject() async {
    final Uri url = Uri.parse("http://10.0.2.2:5000/subject/updatesubject/${widget.subjectId}");
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'courseCode': _courseCodeController.text,
        'name_Subjects': _nameController.text,
        'branchIT': _selectedBranch.contains('IT') ? 1 : 0,
        'branchCS': _selectedBranch.contains('CS') ? 1 : 0,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject updated successfully!')),
      );
      Navigator.of(context).pop(); // Go back to previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subject: ${response.reasonPhrase}')),
      );
    }
  }

  Future<void> showSuccessDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Update'),
          content: Text('Do you want to update this subject?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _updateSubject(); // Call function to update the subject
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Subject',
          style: TextStyle(color: Colors.white), // Text color in AppBar
        ),
        centerTitle: true, // Center text
        backgroundColor: Colors.teal, // AppBar background color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _courseCodeController,
                decoration: InputDecoration(
                  labelText: 'Course Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded border
                    borderSide: BorderSide.none, // No border line
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200], // Background color of input field
                ),
                validator : validateCourseCode,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded border
                    borderSide: BorderSide.none, // No border line
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200], // Background color of input field
                ),
                validator: validateName,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedBranch,
                items: branches.map((String branch) {
                  return DropdownMenuItem<String>(
                    value: branch,
                    child: Text(branch),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBranch = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Branch',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded border
                    borderSide: BorderSide.none, // No border line
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.grey[200], // Background color of input field
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showSuccessDialog(); // Show confirmation dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please check your input')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button color
                  minimumSize: Size(double.infinity, 50), // Button width
                ),
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
