import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kseniia_sksm_24_1/providers/student_provider.dart';
import 'package:kseniia_sksm_24_1/screens/departments.dart';
import 'package:kseniia_sksm_24_1/widgets/students.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProviderScope.containerOf(context, listen: false)
          .read(studentsProvider.notifier)
          .fetchStudents();
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const DepartmentsScreen();
    var activePageTitle = 'Departments';
    if (_selectedPageIndex == 1) {
      activePage = const StudentsScreen();
      activePageTitle = 'Students';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          activePageTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              refreshDB(context);
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Departments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Students',
          )
        ],
      ),
    );
  }

  void refreshDB(BuildContext context) {
    ref.read(studentsProvider.notifier).fetchStudents();
  }
}
