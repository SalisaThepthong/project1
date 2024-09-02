import 'package:flutter/material.dart';
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.black),
            SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
