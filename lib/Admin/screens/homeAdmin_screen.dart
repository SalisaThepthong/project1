import 'package:flutter/material.dart';
import 'package:myproject/Admin/widgets/menu_item.dart';
import 'package:myproject/Admin/screens/subject/showCourse_screen.dart';
import 'package:myproject/Admin/screens/Profes/showGroupProfes_screen.dart';

// หน้าจอหลักของแอป (HomeScreen)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แอปมหาวิทยาลัย',
       theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'TorsilpKanittha', // ชื่อฟอนต์ที่ตั้งค่าไว้ใน pubspec.yaml
      ),
      home: HomeScreen(),
    );
  }
}

// หน้าจอหลักของแอป (HomeScreen)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double iconSize =
        MediaQuery.of(context).size.width * 0.1; // ขนาดไอคอนขึ้นกับหน้าจอ
    final double fontSize =
        MediaQuery.of(context).size.width * 0.04; // ขนาดฟอนต์ขึ้นกับหน้าจอ

    return Scaffold(
      appBar: AppBar(
        title: Text('ยินดีต้อนรับคุณ แอดมิน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // ลดขนาด Padding
        child: Transform.scale(
          scale: 0.6, // ปรับขนาดการซูมของ GridView ที่ 80%
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // ตั้งให้เป็น 2 เสมอ
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1, // ปรับสัดส่วนขนาดของ item ให้เป็นสี่เหลี่ยมจัตุรัส
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final items = [
                {
                  'icon': Icons.school,
                  'text': 'วิชาเรียน',
                  'color': Colors.orangeAccent,
                  'screen': ShowCourseScreen()
                },
                {
                  'icon': Icons.person,
                  'text': 'อาจารย์',
                  'color': Colors.orange.shade100,
                  'screen':  GroupListScreen()
                },
                {
                  'icon': Icons.person_off,
                  'text': 'นักศึกษาไม่ผ่าน',
                  'color': Colors.orange.shade100,
                  'screen': FailedStudentScreen()
                },
                {
                  'icon': Icons.shopping_cart,
                  'text': 'ตะกร้าจัดสรร',
                  'color': Colors.orangeAccent,
                  'screen': AllocationScreen()
                },
                {
                  'icon': Icons.group,
                  'text': 'ผู้ประสานงาน',
                  'color': Colors.orangeAccent,
                  'screen': CoordinatorScreen()
                },
                {
                  'icon': Icons.checklist,
                  'text': 'เช็คโควต้ากลุ่ม',
                  'color': Colors.orange.shade100,
                  'screen': QuotaCheckScreen()
                },
              ];

              return MenuItem(
                icon: items[index]['icon'] as IconData,
                text: items[index]['text'] as String,
                color: items[index]['color'] as Color,
                iconSize: iconSize,
                fontSize: fontSize,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => items[index]['screen'] as Widget),
                  );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // แท็บ 'Home' ถูกไฮไลท์
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ฉัน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'การตั้งค่า',
          ),
        ],
      ),
    );
  }
}


// หน้าต่าง ๆ ที่จะนำทางไป
class TeacherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('อาจารย์'),
      ),
      body: Center(child: Text('หน้านี้แสดงข้อมูลอาจารย์')),
    );
  }
}

class FailedStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('นักศึกษาไม่ผ่าน'),
      ),
      body: Center(child: Text('หน้านี้แสดงรายชื่อนักศึกษาที่ไม่ผ่าน')),
    );
  }
}

class AllocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าจัดสรร'),
      ),
      body: Center(child: Text('หน้านี้แสดงข้อมูลตะกร้าจัดสรร')),
    );
  }
}

class CoordinatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ผู้ประสานงาน'),
      ),
      body: Center(child: Text('หน้านี้แสดงข้อมูลผู้ประสานงาน')),
    );
  }
}

class QuotaCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เช็คโควต้ากลุ่ม'),
      ),
      body: Center(child: Text('หน้านี้แสดงการเช็คโควต้ากลุ่ม')),
    );
  }
}
