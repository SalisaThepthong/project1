import 'package:flutter/material.dart';class Member {
  String? prefix;
  String firstName;
  String lastName;
  String userId;
  bool isFirstMember;
  String? selectedSemester;
  String? selectedYear;
  String? selectedBranch;
  String? selectedCourseYear;
  TextEditingController studentIdController = TextEditingController();

  Member({
    this.prefix,
    required this.firstName,
    required this.lastName,
    required this.userId,
    required this.isFirstMember,
    this.selectedSemester,
    this.selectedYear,
    this.selectedBranch,
    this.selectedCourseYear,
  });
}