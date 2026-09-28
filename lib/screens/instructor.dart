import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'common.dart';

const demoStudents = ['أحمد محمد', 'سارة خالد', 'يوسف علي', 'مريم حسن', 'محمد سمير', 'لينا أحمد', 'عمر خليل', 'نور محمود'];

class InstructorHome extends StatelessWidget {
  const InstructorHome({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة المدرس'), actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsPage())), icon: const Icon(Icons.campaign_outlined))]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        BrandedHeader(name: state.name, subtitle: 'عضو هيئة تدريس • ${state.department}'),
        const SizedBox(height: 14),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.7, mainAxisSpacing: 10, crossAxisSpacing: 10, children: const [
          MetricCard('3', 'محاضرات اليوم', Icons.schedule_rounded, Color(0xFFEAF4FF)),
          MetricCard('108', 'الطلاب', Icons.groups_rounded, Color(0xFFECF8E8)),
          MetricCard('7', 'طلبات الطلبة', Icons.inbox_rounded, Color(0xFFFFF2E7)),
          MetricCard('4', 'مهام أكاديمية', Icons.task_alt_rounded, Color(0xFFF2ECFF)),
        ]),
        const SectionTitle('إجراءات سريعة'),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 8, children: [
          QuickAction(label: 'الحضور', icon: Icons.how_to_reg_rounded, color: Colors.green, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AttendanceManagementPage(course: instructorCourses.first)))),
          QuickAction(label: 'العلامات', icon: Icons.grade_rounded, color: Brand.blue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GradeManagementPage(course: instructorCourses.first)))),
          QuickAction(label: 'إعلان', icon: Icons.campaign_rounded, color: Colors.orange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InstructorAnnouncementPage()))),
          QuickAction(label: 'الإرشاد', icon: Icons.psychology_alt_rounded, color: Colors.deepPurple, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdvisingPage()))),
        ]),
        const SectionTitle('محاضرات اليوم'),
        ...instructorCourses.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: Icons.menu_book_rounded, title: c.name, subtitle: '${c.time} • ${c.room} • ${c.students} طالب', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InstructorCourseDetailsPage(course: c)))))),
        const SectionTitle('خدمات إضافية'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ActionChip(avatar: const Icon(Icons.calendar_month_rounded, size: 18), label: const Text('الجدول التدريسي'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeachingSchedulePage()))),
          ActionChip(avatar: const Icon(Icons.meeting_room_rounded, size: 18), label: const Text('حجز قاعة'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentsPage()))),
          ActionChip(avatar: const Icon(Icons.support_agent_rounded, size: 18), label: const Text('الدعم الفني'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()))),
        ]),
      ]),
    );
  }
}

class InstructorCoursesPage extends StatelessWidget {
  const InstructorCoursesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('مساقاتي')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: instructorCourses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final c = instructorCourses[i];
            return InfoRow(icon: Icons.menu_book_rounded, title: c.name, subtitle: '${c.code} • ${c.students} طالب • ${c.room}', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InstructorCourseDetailsPage(course: c))));
          },
        ),
      );
}

class InstructorCourseDetailsPage extends StatelessWidget {
  final CourseItem course;
  const InstructorCourseDetailsPage({required this.course, super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: course.name, children: [
        InfoRow(icon: Icons.tag_rounded, title: 'رمز المساق', subtitle: course.code),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.groups_rounded, title: 'عدد الطلبة', subtitle: '${course.students} طالب'),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.room_rounded, title: 'الموعد', subtitle: '${course.time} • ${course.room}'),
        const SectionTitle('إدارة المساق'),
        InfoRow(icon: Icons.groups_rounded, title: 'قائمة الطلبة', subtitle: 'عرض الطلبة والملف الأكاديمي', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseStudentsPage(course: course)))),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.how_to_reg_rounded, title: 'تسجيل الحضور', subtitle: 'حاضر / غائب / متأخر / بعذر', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AttendanceManagementPage(course: course)))),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.grade_rounded, title: 'إدارة العلامات', subtitle: 'واجبات، كويز، نصفي، نهائي', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GradeManagementPage(course: course)))),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.campaign_rounded, title: 'إعلانات المساق', subtitle: 'إرسال إعلان لجميع الطلبة', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InstructorAnnouncementPage()))),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.folder_rounded, title: 'ملفات المساق', subtitle: 'رفع محاضرات ومرفقات', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('واجهة رفع الملفات جاهزة للربط بالتخزين السحابي')))),
      ]);
}

class CourseStudentsPage extends StatelessWidget {
  final CourseItem course;
  const CourseStudentsPage({required this.course, super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('طلبة ${course.name}')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: demoStudents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => InfoRow(icon: Icons.person_rounded, title: demoStudents[i], subtitle: '20260${100 + i} • منتظم', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentAcademicProfilePage(name: demoStudents[i])))),
        ),
      );
}

class StudentAcademicProfilePage extends StatelessWidget {
  final String name;
  const StudentAcademicProfilePage({required this.name, super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: 'ملف الطالب', children: [
        Center(child: Column(children: [const CircleAvatar(radius: 40, backgroundColor: Brand.softBlue, child: Icon(Icons.person_rounded, size: 48, color: Brand.blue)), const SizedBox(height: 10), Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const Text('طالب منتظم')])) ,
        const SizedBox(height: 20),
        const Row(children: [Expanded(child: MetricCard('3.21', 'المعدل', Icons.auto_graph_rounded, Color(0xFFEAF4FF))), SizedBox(width: 10), Expanded(child: MetricCard('81', 'الساعات', Icons.school_rounded, Color(0xFFECF8E8)))]),
        const SectionTitle('تنبيهات أكاديمية'),
        const InfoRow(icon: Icons.info_outline_rounded, title: 'الوضع الأكاديمي', subtitle: 'لا توجد إنذارات أكاديمية'),
      ]);
}

class AttendanceManagementPage extends StatefulWidget {
  final CourseItem course;
  const AttendanceManagementPage({required this.course, super.key});
  @override
  State<AttendanceManagementPage> createState() => _AttendanceManagementPageState();
}

class _AttendanceManagementPageState extends State<AttendanceManagementPage> {
  final Map<String, String> values = {for (final s in demoStudents) s: 'حاضر'};
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('الحضور — ${widget.course.code}')),
        body: Column(children: [
          Expanded(child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: demoStudents.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (_, i) { final s = demoStudents[i]; return Card(child: ListTile(title: Text(s, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('20260${100 + i}'), trailing: DropdownButton<String>(value: values[s], items: ['حاضر', 'غائب', 'متأخر', 'بعذر'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => values[s] = v!)))); })),
          SafeArea(top: false, child: Padding(padding: const EdgeInsets.all(16), child: FilledButton.icon(onPressed: () { final state = AppStateScope.of(context); for (final e in values.entries) { state.saveAttendance(widget.course.code, e.key, e.value); } ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الحضور'))); }, icon: const Icon(Icons.save_rounded), label: const Text('حفظ الحضور')))),
        ]),
      );
}

class GradeManagementPage extends StatefulWidget {
  final CourseItem course;
  const GradeManagementPage({required this.course, super.key});
  @override
  State<GradeManagementPage> createState() => _GradeManagementPageState();
}

class _GradeManagementPageState extends State<GradeManagementPage> {
  String assessment = 'الامتحان النصفي';
  late final Map<String, TextEditingController> controllers = {for (final s in demoStudents) s: TextEditingController(text: '25')};
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('العلامات — ${widget.course.code}')),
        body: Column(children: [
          Padding(padding: const EdgeInsets.all(16), child: DropdownButtonFormField<String>(value: assessment, decoration: const InputDecoration(labelText: 'نوع التقييم'), items: ['واجب', 'كويز', 'الامتحان النصفي', 'الامتحان النهائي'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => assessment = v!))),
          Expanded(child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: demoStudents.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (_, i) { final s = demoStudents[i]; return Card(child: ListTile(title: Text(s), trailing: SizedBox(width: 90, child: TextField(controller: controllers[s], keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: const InputDecoration(hintText: 'العلامة'))))); })),
          SafeArea(top: false, child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Expanded(child: OutlinedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ كمسودة'))), child: const Text('حفظ كمسودة'))), const SizedBox(width: 10), Expanded(child: FilledButton(onPressed: () { final state = AppStateScope.of(context); for (final e in controllers.entries) { state.saveGrade(widget.course.code, e.key, double.tryParse(e.value.text) ?? 0); } ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم اعتماد العلامات'))); }, child: const Text('اعتماد العلامات')))]))),
        ]),
      );
}

class InstructorAnnouncementPage extends StatefulWidget {
  const InstructorAnnouncementPage({super.key});
  @override
  State<InstructorAnnouncementPage> createState() => _InstructorAnnouncementPageState();
}

class _InstructorAnnouncementPageState extends State<InstructorAnnouncementPage> {
  final title = TextEditingController();
  final body = TextEditingController();
  String course = instructorCourses.first.code;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('إرسال إعلان')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          DropdownButtonFormField<String>(value: course, decoration: const InputDecoration(labelText: 'المساق'), items: instructorCourses.map((c) => DropdownMenuItem(value: c.code, child: Text('${c.code} — ${c.name}'))).toList(), onChanged: (v) => setState(() => course = v!)),
          const SizedBox(height: 12),
          TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان الإعلان')),
          const SizedBox(height: 12),
          TextField(controller: body, maxLines: 6, decoration: const InputDecoration(labelText: 'نص الإعلان', alignLabelWithHint: true)),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الإعلان لطلبة المساق'))), icon: const Icon(Icons.send_rounded), label: const Text('نشر الإعلان')),
        ]),
      );
}

class InstructorRequestsPage extends StatelessWidget {
  const InstructorRequestsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات الطلبة')),
      body: ListView.separated(padding: const EdgeInsets.all(16), itemCount: state.requests.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) { final r = state.requests[i]; return Card(child: ListTile(leading: const CircleAvatar(backgroundColor: Brand.softBlue, child: Icon(Icons.description_rounded, color: Brand.blue)), title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('${r.id} • ${r.category}\n${r.status.label}'), isThreeLine: true, trailing: PopupMenuButton<RequestStatus>(onSelected: (s) => state.updateRequest(r, s), itemBuilder: (_) => [const PopupMenuItem(value: RequestStatus.approved, child: Text('اعتماد')), const PopupMenuItem(value: RequestStatus.needsEdit, child: Text('طلب تعديل')), const PopupMenuItem(value: RequestStatus.rejected, child: Text('رفض'))]))); }),
    );
  }
}

class AdvisingPage extends StatelessWidget {
  const AdvisingPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الإرشاد الأكاديمي')),
        body: ListView.separated(padding: const EdgeInsets.all(16), itemCount: demoStudents.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (_, i) => InfoRow(icon: Icons.psychology_alt_rounded, title: demoStudents[i], subtitle: 'الساعات المنجزة: ${60 + i * 3} • المعدل: ${(2.8 + i * .07).toStringAsFixed(2)}', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentAcademicProfilePage(name: demoStudents[i]))))),
      );
}

class TeachingSchedulePage extends StatelessWidget {
  const TeachingSchedulePage({super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: 'الجدول التدريسي', children: instructorCourses.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: Icons.schedule_rounded, title: c.name, subtitle: '${c.time} • ${c.room} • ${c.students} طالب'))).toList());
}
