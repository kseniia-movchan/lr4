import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kseniia_sksm_24_1/models/student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kseniia_sksm_24_1/providers/department_provider.dart';

const db = 'students-list-6944b-default-rtdb.firebaseio.com';
final url =
    Uri.https(db, 'students.json');

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier(this.ref, super.state);
  final Ref ref;
  var isLoading = false;

  void addStudent(Student student) async {
    isLoading = true;
    state = [...state];
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': student.id,
          'firstName': student.firstName,
          'lastName': student.lastName,
          'departmentId': student.department.id, 
          'grade': student.grade,
          'gender': student.gender.name,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final firebaseKey = responseData['name'];
        final updatedStudent = student.copyWith(fKey: firebaseKey);
        state = [...state, updatedStudent];
      } else {
        throw Exception('Failed to add');
      }
    } catch (e) {
      print('Error adding student: $e');
    } finally {
      isLoading = false;
      state = [...state];
    }
  }

  void editStudent(Student student, int index) async {
    isLoading = true;
    try {
      final newState = [...state];
      newState[index] = newState[index].copyWith(
        firstName: student.firstName,
        lastName: student.lastName,
        department: student.department,
        gender: student.gender,
        grade: student.grade,
      );
      state = newState;

      final urlItem = Uri.https(
        db,
        'students/${student.fKey}.json',
      );

      final response = await http.patch(
        urlItem,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'firstName': student.firstName,
          'lastName': student.lastName,
          'departmentId': student.department.id,
          'gender': student.gender.name,
          'grade': student.grade,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        print('PATCH Body: ${json.encode({
              'firstName': student.firstName,
              'lastName': student.lastName,
              'departmentId': student.department.id,
              'gender': student.gender.name,
              'grade': student.grade,
            })}');
      }
    } catch (e) {
      print('Error updating student info: $e');
    } finally {
      isLoading = false;
      state = [...state];
    }
  }

  void insertStudentLocal(Student student, int index) {
    state = [
      ...state.sublist(0, index),
      student,
      ...state.sublist(index),
    ];
  }

  void removeStudentLocal(Student student) {
    state = state.where((m) => m.id != student.id).toList();
  }

  void removeStudent(Student student) async {
    final urlItem = Uri.https(db,
        'students/${student.fKey}.json');
    isLoading = true;
    try {
      final previousState = state;
      state = state.where((m) => m.id != student.id).toList();
      final response = await http.delete(urlItem);
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        state = previousState;
      }
    } catch (e) {
      print('Error deleting a student: $e');
    } finally {
      isLoading = false;
      state = [...state];
    }
  }

  void fetchStudents() async {
    isLoading = true;
    state = [...state];
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = response.body;
        final parsed = json.decode(body);

        if (parsed == null || parsed == 'null') {
          print('Database is empty.');
          state = [];
          return;
        }

        if (parsed is Map<String, dynamic>) {
          final List<Student> students = [];
          for (var entry in parsed.entries) {
            final departmentId = entry.value['departmentId'];
            final department = ref
                .read(departmentsProvider)
                .firstWhere((d) => d.id == departmentId);

            if (department != null) {
              students.add(
                Student(
                  id: entry.value['id'] ?? '',
                  fKey: entry.key,
                  firstName: entry.value['firstName'] ?? '',
                  lastName: entry.value['lastName'] ?? '',
                  department: department,
                  grade: entry.value['grade'] ?? 0,
                  gender: Gender.values.firstWhere(
                    (gen) => gen.name == entry.value['gender'],
                    orElse: () => Gender.female,
                  ),
                ),
              );
            } else {
              print('Department not found for ID: $departmentId');
            }
          }
          state = students;
        } else {
          print('Unexpected data format received.');
          state = [];
        }
      } else {
        print('Failed to fetch students: ${response.statusCode}');
        state = [];
      }
    } catch (e) {
      print('Error fetching students: $e');
      state = [];
    } finally {
      isLoading = false;
      state = [...state];
    }
  }
}

// Students provider
final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>(
  (ref) {
    return StudentsNotifier(ref, []);
  },
);
