import 'package:flutter/material.dart';
import 'package:kseniia_sksm_24_1/models/student.dart';


class StudentItem extends StatelessWidget {
  final Student student; 

  const StudentItem({super.key, required this.student});

  Color _getGenderColor(Gender gender) {
    return gender == Gender.male ? Colors.blue : Colors.pink;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: _getGenderColor(student.gender), 
        borderRadius: BorderRadius.circular(12.0), 
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            student.department.icon, 
            color: _getGenderColor(student.gender),
          ),
        ),
        title: Text(
          '${student.firstName} ${student.lastName}',
          style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary)
        ),
        subtitle: Text(
          'Grade: ${student.grade}',
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        trailing: Text(
          student.grade.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Глобальна змінна для іконок департаментів
// final Map<Department, IconData> departmentIcons = {
//   Department.finance: Icons.attach_money,
//   Department.law: Icons.gavel,
//   Department.it: Icons.computer,
//   Department.medical: Icons.local_hospital,
// };
