// import 'package:intl/intl.dart';
//
// class Utils {
//   static int calculateAge(String dob) {
//     DateTime birthDate = DateFormat('dd/MM/yyyy').parse(dob);
//     DateTime today = DateTime.now();
//     int age = today.year - birthDate.year;
//     if (today.month < birthDate.month ||
//         (today.month == birthDate.month && today.day < birthDate.day)) {
//       age--;
//     }
//     return age;
//   }
// }

import 'package:intl/intl.dart';

class Utils {
  static int calculateAge(int timestamp) {
    DateTime birthDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

