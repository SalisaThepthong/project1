import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditGroupScreen extends StatefulWidget {
  final String groupId;
  const EditGroupScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final TextEditingController groupNumberController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGroupDetails(widget.groupId); // Call the method to fetch group details
  }

  Future<void> fetchGroupDetails(String groupId) async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/get_group/$groupId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Fetched Data: $data'); // Debug print to check the fetched data

      // Convert `group_Number` to a String if it's an integer
      final groupNumber = data['group_Number'].toString();
      final groupName = data['group_Name'] as String;

      setState(() {
        groupNumberController.text = groupNumber;
        groupNameController.text = groupName;
      });
    } else {
      // Handle error with a message
      print('Failed to fetch group details: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch group details')),
      );
    }
  } catch (e) {
    print('Error fetching group details: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching group details')),
    );
  }
}


  Future<void> updateGroup() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/update_group/${widget.groupId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'group_Number': groupNumberController.text,
          'group_Name': groupNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update group')),
        );
      }
    } catch (e) {
      print('Error updating group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating group')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: groupNumberController,
              decoration: InputDecoration(labelText: 'Group Number'),
            ),
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateGroup,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
