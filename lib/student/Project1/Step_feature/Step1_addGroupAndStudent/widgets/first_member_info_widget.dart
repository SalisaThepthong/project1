// first_member_info_widget.dart
import 'package:flutter/material.dart';
import '../models/model_member.dart';

class FirstMemberInfoWidget extends StatelessWidget {
  final Member member;

  const FirstMemberInfoWidget({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person, color: Colors.purple),
            SizedBox(width: 10),
            Text('${member.prefix} ${member.firstName} ${member.lastName}'),
          ],
        ),
        SizedBox(height: 10),
        Text('ข้อมูลจาก User ที่ login'),
        SizedBox(height: 10),
        TextFormField(
          initialValue: member.prefix,
          decoration: InputDecoration(labelText: 'คำนำหน้า', border: OutlineInputBorder()),
          onChanged: (value) {
            member.prefix = value;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          initialValue: member.firstName,
          decoration: InputDecoration(labelText: 'ชื่อ', border: OutlineInputBorder()),
          onChanged: (value) {
            member.firstName = value;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          initialValue: member.lastName,
          decoration: InputDecoration(labelText: 'นามสกุล', border: OutlineInputBorder()),
          onChanged: (value) {
            member.lastName = value;
          },
        ),
      ],
    );
  }
}
