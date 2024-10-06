import 'package:flutter/material.dart';

//  Widget buildDropdown(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
//     return Expanded(
//       child: DropdownButtonFormField<String>(
//         isExpanded: true,
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//         value: selectedValue,
//         items: items.map((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }

Widget buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }