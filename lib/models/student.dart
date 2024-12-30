import 'package:uuid/uuid.dart';

import 'package:kseniia_sksm_24_1/models/department.dart';

//enum Department { finance, law, it, medical }

enum Gender { male, female }

// Глобальна змінна з іконками для кожної спеціальності
// final Map<Department, IconData> departmentIcons = {
//   Department.finance: Icons.attach_money,
//   Department.law: Icons.gavel,
//   Department.it: Icons.computer,
//   Department.medical: Icons.local_hospital,
// };

class Student {
  final String id;
  final String fKey;
  final String firstName;
  final String lastName;
  final Department department;
  final int grade;
  final Gender gender;

  Student({
    String? id,
    required this.fKey,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender,
  }) : id = id ?? const Uuid().v4();

  Student copyWith({
    String? fKey,
    String? firstName,
    String? lastName,
    Department? department,
    Gender? gender,
    int? grade,
  }) {
    return Student(
      id: id,
      fKey: fKey ?? this.fKey,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      department: department ?? this.department,
      gender: gender ?? this.gender,
      grade: grade ?? this.grade,
    );
  }
}
