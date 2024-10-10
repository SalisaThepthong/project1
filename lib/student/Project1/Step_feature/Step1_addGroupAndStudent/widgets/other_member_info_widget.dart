// other_member_info_widget.dart
import 'package:flutter/material.dart';
import '../models/model_member.dart';
import '../controllers/member_controller.dart';

class OtherMemberInfoWidget extends StatelessWidget {
  final Member member;
  final AddMembersController controller;

  const OtherMemberInfoWidget({
    Key? key,
    required this.member,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'คำนำหน้า', border: OutlineInputBorder()),
          value: member.prefix ?? controller.prefixes[0],
          items: controller.prefixes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            member.prefix = newValue;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(labelText: 'ชื่อ', border: OutlineInputBorder()),
          onChanged: (value) {
            member.firstName = value;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(labelText: 'นามสกุล', border: OutlineInputBorder()),
          onChanged: (value) {
            member.lastName = value;
          },
        ),
      ],
    );
  }
}