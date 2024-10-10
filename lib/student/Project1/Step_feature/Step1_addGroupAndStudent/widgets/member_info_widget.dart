// member_info_widget.dart
import 'package:flutter/material.dart';
import '../models/model_member.dart';
import '../controllers/member_controller.dart';
import 'first_member_info_widget.dart';
import 'other_member_info_widget.dart';

class MemberInfoWidget extends StatelessWidget {
  final Member member;
  final int index;
  final AddMembersController controller;

  const MemberInfoWidget({
    Key? key,
    required this.member,
    required this.index,
    required this.controller,
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
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สมาชิกท่านที่ ${index + 1}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          if (index == 0)
            FirstMemberInfoWidget(member: member)
          else
            OtherMemberInfoWidget(member: member, controller: controller),
          SizedBox(height: 15),
          _buildCommonFields(),
          if (index != 0)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.removeMember(index),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommonFields() {
    return Column(
      children: [
        TextFormField(
          controller: member.studentIdController,
          decoration: const InputDecoration(
            labelText: 'รหัสนักศึกษา',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.assignment_ind, color: Colors.purple),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.warning, color: Color.fromARGB(255, 236, 163, 45)),
            SizedBox(width: 8),
            Text(
              'ภาคการศึกษาและปีการศึกษา ในปัจจุบัน',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'ภาคการศึกษา',
                  border: OutlineInputBorder(),
                ),
                value: member.selectedSemester ?? controller.semesters[0],
                items: controller.semesters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  member.selectedSemester = newValue;
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'ปีการศึกษา',
                  border: OutlineInputBorder(),
                ),
                value: member.selectedYear ?? controller.years[0],
                items: controller.years.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  member.selectedYear = newValue;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'สาขา',
            border: OutlineInputBorder(),
          ),
          value: member.selectedBranch ?? controller.branches[0],
          items: controller.branches.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            member.selectedBranch = newValue;
          },
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'ปีหลักสูตรที่เรียน',
            border: OutlineInputBorder(),
          ),
          value: member.selectedCourseYear ?? controller.years[0],
          items: controller.years.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            member.selectedCourseYear = newValue;
          },
        ),
      ],
    );
  }
}