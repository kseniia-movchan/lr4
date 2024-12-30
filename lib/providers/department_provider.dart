import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kseniia_sksm_24_1/models/department.dart';

final  availableDepartments = [
  Department(
    id: 'd1',
    name: 'Finance',
    color: Colors.green.shade900,
    icon: Icons.attach_money,
  ),
  Department(
    id: 'd2',
    name: 'Law',
    color: Colors.red.shade700,
    icon:  Icons.gavel,
  ),
  Department(
    id: 'd3',
    name: 'IT',
    color: Colors.blue.shade600,
    icon: Icons.computer,
  ),
  Department(
    id: 'd4',
    name: 'Medical',
    color: Colors.purple.shade700,
    icon: Icons.local_hospital,
  ),
];

// final Map<Department, IconData> departmentIcons = {
//   Department.finance: Icons.attach_money,
//   Department.law: Icons.gavel,
//   Department.it: Icons.computer,
//   Department.medical: Icons.local_hospital,
// };

final departmentsProvider = Provider((ref) {
  return availableDepartments;
});
