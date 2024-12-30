import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kseniia_sksm_24_1/models/student.dart';
import 'package:kseniia_sksm_24_1/providers/student_provider.dart';
import 'package:kseniia_sksm_24_1/widgets/new_student.dart';
import 'package:kseniia_sksm_24_1/widgets/student_item.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final isLoading = ref.watch(studentsProvider.notifier).isLoading;

    Future<void> addNewStudent(BuildContext context) async {
      final newStudent = await showModalBottomSheet<Student>(
        context: context,
        builder: (ctx) => const NewStudent(),
      );
      if (newStudent != null) {
        ref.read(studentsProvider.notifier).addStudent(newStudent);
      }
    }

    void editStudent(BuildContext context, Student student, int index) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewStudent(student: student),
        ),
      ).then((updatedStudent) {
        if (updatedStudent != null && updatedStudent is Student) {
          final index = students.indexWhere((s) => s.id == student.id);
          ref
              .read(studentsProvider.notifier)
              .editStudent(updatedStudent, index);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              addNewStudent(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

                return Dismissible(
                  key: Key(student.firstName + student.lastName),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    final removedStudent = student;
                    final studentIndex =
                        students.indexWhere((s) => s.id == student.id);
                    final state = ref.read(studentsProvider.notifier);
                    state.removeStudentLocal(student);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                          SnackBar(
                            content: Text(
                                '${removedStudent.firstName} ${removedStudent.lastName} removed'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                state.insertStudentLocal(student, studentIndex);
                              },
                            ),
                          ),
                        )
                        .closed
                        .then(
                      (reason) {
                        if (reason != SnackBarClosedReason.action) {
                          state.removeStudent(student);
                        }
                      },
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () {
                      editStudent(context, student, index);
                    },
                    child: StudentItem(student: student),
                  ),
                );
              },
            ),
    );
  }
}
