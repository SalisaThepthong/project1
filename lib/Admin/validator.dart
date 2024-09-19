
// เมธอดสำหรับตรวจสอบว่าห้ามเป็นค่าว่างและห้ามมีตัวเลขหรืออักขระพิเศษ
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกข้อมูล'; // ตรวจสอบว่าไม่เป็นค่าว่าง
  } 
  return null; // ผ่านการตรวจสอบ
}



// เมธอดตรวจสอบรหัสวิชา: ต้องเป็นตัวเลขเท่านั้น และต้องไม่เกิน 6 ตัว
String? validateCourseCode(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณาใส่รหัสวิชา';
  } else if (!RegExp(r'^\d+$').hasMatch(value)) {
    return 'กรุณาใส่ตัวเลขเท่านั้น';
  } else if (value.length > 6) {
    return 'รหัสวิชาต้องไม่เกิน 6 ตัวเลข';
  }
  return null; // ถ้าไม่มีข้อผิดพลาด
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกอีเมล'; // ตรวจสอบว่าไม่เป็นค่าว่าง
  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
    return 'กรุณากรอกอีเมลที่ถูกต้อง'; // ตรวจสอบว่าอีเมลมีรูปแบบถูกต้อง
  }
  return null; // ผ่านการตรวจสอบ
}

// // เมธอดตรวจสอบชื่อวิชา: ห้ามเป็นค่าว่าง
// String? validateSubjectName(String? value) {
//   if (value == null || value.isEmpty) {
//     return 'กรุณาใส่ชื่อวิชา';
//   }
//   return null; // ถ้าไม่มีข้อผิดพลาด
// }

