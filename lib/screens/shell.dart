import 'package:flutter/material.dart';
import '../models.dart';
import '../state.dart';
import 'common.dart';
import 'employee.dart';
import 'instructor.dart';
import 'student.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  List<Widget> pages(UserRole role) => switch (role) {
        UserRole.student => const [StudentHome(), ServicesPage(), StudentRequestsPage(), NotificationsPage(), ProfilePage()],
        UserRole.instructor => const [InstructorHome(), InstructorCoursesPage(), InstructorRequestsPage(), NotificationsPage(), ProfilePage()],
        UserRole.employee => const [EmployeeHome(), IncomingRequestsPage(), EmployeeTasksPage(), NotificationsPage(), ProfilePage()],
      };

  List<NavigationDestination> nav(UserRole role) => switch (role) {
        UserRole.student => const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'الخدمات'),
            NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description_rounded), label: 'طلباتي'),
            NavigationDestination(icon: Icon(Icons.notifications_none_rounded), selectedIcon: Icon(Icons.notifications_rounded), label: 'الإشعارات'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'حسابي'),
          ],
        UserRole.instructor => const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'مساقاتي'),
            NavigationDestination(icon: Icon(Icons.inbox_outlined), selectedIcon: Icon(Icons.inbox_rounded), label: 'الطلبات'),
            NavigationDestination(icon: Icon(Icons.notifications_none_rounded), selectedIcon: Icon(Icons.notifications_rounded), label: 'الإشعارات'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'حسابي'),
          ],
        UserRole.employee => const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.inbox_outlined), selectedIcon: Icon(Icons.inbox_rounded), label: 'الوارد'),
            NavigationDestination(icon: Icon(Icons.task_outlined), selectedIcon: Icon(Icons.task_rounded), label: 'المهام'),
            NavigationDestination(icon: Icon(Icons.notifications_none_rounded), selectedIcon: Icon(Icons.notifications_rounded), label: 'الإشعارات'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'حسابي'),
          ],
      };

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final body = pages(state.role);
    final destinations = nav(state.role);
    if (index >= body.length) index = 0;
    return Scaffold(
      body: IndexedStack(index: index, children: body),
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (i) => setState(() => index = i), destinations: destinations),
    );
  }
}
