import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool loggedIn = false;
  UserRole role = UserRole.student;
  String name = 'عز الدين أبو جبل';
  String userId = '20260001';
  String department = 'تكنولوجيا المعلومات';

  final List<RequestItem> requests = [
    RequestItem(id: 'REQ-2026-1048', title: 'طلب إفادة طالب', category: 'القبول والتسجيل', status: RequestStatus.review, date: '28/09/2026'),
    RequestItem(id: 'REQ-2026-1031', title: 'طلب مراجعة علامة', category: 'الخدمات الأكاديمية', status: RequestStatus.completed, date: '26/09/2026'),
    RequestItem(id: 'REQ-2026-1012', title: 'طلب تقسيط', category: 'الخدمات المالية', status: RequestStatus.approved, date: '22/09/2026'),
  ];

  final List<NotificationItem> notifications = [
    NotificationItem('تحديث على طلبك', 'طلب إفادة الطالب أصبح قيد المراجعة.', Icons.description_rounded, 'منذ 10 دقائق'),
    NotificationItem('محاضرة قادمة', 'لديك محاضرة تصميم UX/UI الساعة 09:00.', Icons.schedule_rounded, 'منذ ساعة'),
    NotificationItem('إعلان جديد', announcementsSeed.first.title, Icons.campaign_rounded, 'اليوم'),
  ];

  final List<AppointmentItem> appointments = [];
  final List<TicketItem> tickets = [TicketItem('TKT-1008', 'مشكلة في البريد الجامعي', 'الدعم الفني', TicketStatus.processing)];
  final List<TaskItem> tasks = [
    TaskItem('مراجعة طلبات الطلبة الجديدة', 'عالية'),
    TaskItem('رفع تقرير القسم الأسبوعي', 'متوسطة'),
    TaskItem('اعتماد كشوف الحضور', 'متوسطة', done: true),
  ];
  final Map<String, Map<String, String>> attendance = {};
  final Map<String, Map<String, double>> grades = {};

  AppState(this.prefs) {
    loggedIn = prefs.getBool('loggedIn') ?? false;
    final storedRole = prefs.getString('role') ?? 'student';
    role = UserRole.values.firstWhere((r) => r.name == storedRole, orElse: () => UserRole.student);
    name = prefs.getString('name') ?? name;
  }

  Future<void> login(String username, String password, UserRole selectedRole) async {
    if (username.trim().isEmpty || password.trim().isEmpty) throw Exception('يرجى إدخال بيانات الدخول');
    loggedIn = true;
    role = selectedRole;
    userId = username.trim();
    name = switch (role) {
      UserRole.student => 'عز الدين أبو جبل',
      UserRole.instructor => 'د. عز الدين أبو جبل',
      UserRole.employee => 'م. عز الدين أبو جبل',
    };
    await prefs.setBool('loggedIn', true);
    await prefs.setString('role', role.name);
    await prefs.setString('name', name);
    notifyListeners();
  }

  Future<void> logout() async {
    loggedIn = false;
    await prefs.setBool('loggedIn', false);
    notifyListeners();
  }

  void addRequest(String title, String category, String notes) {
    final id = 'REQ-2026-${1100 + requests.length}';
    requests.insert(0, RequestItem(id: id, title: title, category: category, status: RequestStatus.submitted, date: '28/09/2026', notes: notes));
    notifications.insert(0, NotificationItem('تم إرسال الطلب', '$title برقم $id', Icons.check_circle_rounded, 'الآن'));
    notifyListeners();
  }

  void updateRequest(RequestItem request, RequestStatus status) {
    request.status = status;
    notifications.insert(0, NotificationItem('تحديث حالة الطلب', '${request.title}: ${status.label}', Icons.sync_rounded, 'الآن'));
    notifyListeners();
  }

  void markNotificationsRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  void addAppointment(String department, String date, String time, String reason) {
    appointments.add(AppointmentItem(department, date, time, reason));
    notifyListeners();
  }

  void addTicket(String title, String department) {
    tickets.insert(0, TicketItem('TKT-${1010 + tickets.length}', title, department, TicketStatus.open));
    notifyListeners();
  }

  void toggleTask(TaskItem task) {
    task.done = !task.done;
    notifyListeners();
  }

  void saveAttendance(String courseCode, String student, String value) {
    attendance.putIfAbsent(courseCode, () => {});
    attendance[courseCode]![student] = value;
    notifyListeners();
  }

  void saveGrade(String courseCode, String student, double value) {
    grades.putIfAbsent(courseCode, () => {});
    grades[courseCode]![student] = value;
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState notifier, required super.child}) : super(notifier: notifier);
  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.notifier!;
}
