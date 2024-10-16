import 'package:flutter/material.dart';

class ProfileController {
  void logout(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}