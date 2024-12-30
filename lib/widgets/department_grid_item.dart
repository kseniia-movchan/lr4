import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kseniia_sksm_24_1/models/department.dart';
import 'package:kseniia_sksm_24_1/providers/student_provider.dart';

class DepartmentGridItem extends ConsumerWidget {
  const DepartmentGridItem({super.key, required this.department});

  final Department department;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final amount = students
        .where((student) => student.department.id == department.id)
        .length;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            department.color.withValues(alpha: 0.6),
            department.color.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Icon(
                department.icon,
                color: Colors.white,
              ),
            ],
          ),
          Text(
            department.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          Text(
            'students enrolled : $amount',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ],
      ),
    );
  }
}
