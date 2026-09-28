import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'common.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية'), actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsPage())), icon: const Icon(Icons.campaign_outlined))]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        BrandedHeader(name: state.name, subtitle: 'طالب • ${state.department}'),
        const SizedBox(height: 14),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.7, mainAxisSpacing: 10, crossAxisSpacing: 10, children: const [
          MetricCard('3', 'المحاضرات اليوم', Icons.menu_book_rounded, Color(0xFFEAF4FF)),
          MetricCard('2', 'طلبات مفتوحة', Icons.description_rounded, Color(0xFFFFF2E7)),
          MetricCard('1', 'اختبار قريب', Icons.quiz_rounded, Color(0xFFF2ECFF)),
          MetricCard('4', 'إشعارات جديدة', Icons.notifications_rounded, Color(0xFFECF8E8)),
        ]),
        const SectionTitle('الخدمات السريعة'),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 8, children: [
          QuickAction(label: 'جدولي', icon: Icons.calendar_month_rounded, color: Brand.blue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SchedulePage()))),
          QuickAction(label: 'علاماتي', icon: Icons.bar_chart_rounded, color: Colors.green, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesPage()))),
          QuickAction(label: 'خطتي', icon: Icons.route_rounded, color: Colors.deepPurple, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AcademicPlanPage()))),
          QuickAction(label: 'بطاقتي', icon: Icons.badge_rounded, color: Colors.orange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DigitalIdPage()))),
        ]),
        const SectionTitle('محاضرات اليوم'),
        ...studentCourses.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: Icons.menu_book_rounded, title: c.name, subtitle: '${c.time} • ${c.room}\n${c.instructor}', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentCoursePage(course: c)))))),
        const SectionTitle('خدمات مهمة'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ActionChip(avatar: const Icon(Icons.fact_check_rounded, size: 18), label: const Text('الامتحانات'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamsPage()))),
          ActionChip(avatar: const Icon(Icons.wallet_rounded, size: 18), label: const Text('المالية'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancePage()))),
          ActionChip(avatar: const Icon(Icons.how_to_reg_rounded, size: 18), label: const Text('الحضور'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendancePage()))),
          ActionChip(avatar: const Icon(Icons.event_available_rounded, size: 18), label: const Text('حجز موعد'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentsPage()))),
          ActionChip(avatar: const Icon(Icons.support_agent_rounded, size: 18), label: const Text('الدعم'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()))),
        ]),
      ]),
    );
  }
}

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});
  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String query = '';
  String category = 'الكل';
  @override
  Widget build(BuildContext context) {
    final categories = ['الكل', ...{for (final s in services) s.category}];
    final filtered = services.where((s) => (category == 'الكل' || s.category == category) && (query.isEmpty || s.title.contains(query) || s.subtitle.contains(query))).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('الخدمات الجامعية')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(hintText: 'ابحث عن خدمة...', prefixIcon: Icon(Icons.search_rounded)))),
        SizedBox(height: 44, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 16), scrollDirection: Axis.horizontal, itemBuilder: (_, i) { final c = categories[i]; return ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)); }, separatorBuilder: (_, __) => const SizedBox(width: 8), itemCount: categories.length)),
        const SizedBox(height: 8),
        Expanded(child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: filtered.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) { final s = filtered[i]; return InfoRow(icon: s.icon, title: s.title, subtitle: '${s.category}\n${s.subtitle}', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceDetailsPage(service: s)))); })),
      ]),
    );
  }
}

class ServiceDetailsPage extends StatelessWidget {
  final ServiceItem service;
  const ServiceDetailsPage({required this.service, super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(service.title)),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          CircleAvatar(radius: 38, backgroundColor: service.tint, child: Icon(service.icon, size: 38, color: Brand.blue)),
          const SizedBox(height: 16),
          Text(service.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 8),
          Text(service.subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 24),
          const InfoRow(icon: Icons.apartment_rounded, title: 'الجهة المختصة', subtitle: 'القسم المسؤول حسب نوع الخدمة'),
          const SizedBox(height: 10),
          const InfoRow(icon: Icons.schedule_rounded, title: 'مدة المعالجة', subtitle: 'من يوم إلى 5 أيام عمل'),
          const SizedBox(height: 10),
          const InfoRow(icon: Icons.attach_file_rounded, title: 'المرفقات', subtitle: 'قد تتطلب الخدمة مستندات داعمة'),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SubmitRequestPage(service: service))), icon: const Icon(Icons.send_rounded), label: const Text('بدء الطلب')),
        ]),
      );
}

class SubmitRequestPage extends StatefulWidget {
  final ServiceItem service;
  const SubmitRequestPage({required this.service, super.key});
  @override
  State<SubmitRequestPage> createState() => _SubmitRequestPageState();
}

class _SubmitRequestPageState extends State<SubmitRequestPage> {
  final notes = TextEditingController();
  String semester = 'الفصل الأول 2026/2027';
  bool confirm = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('تقديم: ${widget.service.title}')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          DropdownButtonFormField<String>(value: semester, decoration: const InputDecoration(labelText: 'الفصل الدراسي'), items: ['الفصل الأول 2026/2027', 'الفصل الثاني 2026/2027'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => semester = v!)),
          const SizedBox(height: 12),
          TextField(controller: notes, maxLines: 5, decoration: const InputDecoration(labelText: 'تفاصيل / سبب الطلب', alignLabelWithHint: true)),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت محاكاة اختيار ملف للمرفق'))), icon: const Icon(Icons.upload_file_rounded), label: const Text('إضافة مرفق')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: confirm, onChanged: (v) => setState(() => confirm = v ?? false), title: const Text('أقر بصحة البيانات المدخلة.')),
          const SizedBox(height: 10),
          FilledButton.icon(onPressed: confirm ? () { AppStateScope.of(context).addRequest(widget.service.title, widget.service.category, notes.text); Navigator.popUntil(context, (route) => route.isFirst); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الطلب بنجاح'))); } : null, icon: const Icon(Icons.check_circle_rounded), label: const Text('إرسال الطلب')),
        ]),
      );
}

class StudentRequestsPage extends StatefulWidget {
  const StudentRequestsPage({super.key});
  @override
  State<StudentRequestsPage> createState() => _StudentRequestsPageState();
}

class _StudentRequestsPageState extends State<StudentRequestsPage> {
  RequestStatus? filter;
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final items = state.requests.where((r) => filter == null || r.status == filter).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: Column(children: [
        SizedBox(height: 52, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), children: [
          ChoiceChip(label: const Text('الكل'), selected: filter == null, onSelected: (_) => setState(() => filter = null)),
          const SizedBox(width: 8),
          ...[RequestStatus.submitted, RequestStatus.review, RequestStatus.approved, RequestStatus.completed].map((s) => Padding(padding: const EdgeInsets.only(left: 8), child: ChoiceChip(label: Text(s.label), selected: filter == s, onSelected: (_) => setState(() => filter = s)))),
        ])),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final r = items[i];
              return Card(
                child: ListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RequestDetailsPage(request: r))),
                  leading: CircleAvatar(
                    backgroundColor: r.status.color.withValues(alpha: .12),
                    child: Icon(Icons.description_rounded, color: r.status.color),
                  ),
                  title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${r.id} • ${r.date}\n${r.category}'),
                  isThreeLine: true,
                  trailing: Chip(
                    label: Text(r.status.label),
                    side: BorderSide.none,
                    backgroundColor: r.status.color.withValues(alpha: .12),
                    labelStyle: TextStyle(color: r.status.color, fontSize: 11),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class RequestDetailsPage extends StatelessWidget {
  final RequestItem request;
  const RequestDetailsPage({required this.request, super.key});
  @override
  Widget build(BuildContext context) {
    final steps = ['تم تقديم الطلب', 'تم استلام الطلب', 'قيد مراجعة الجهة المختصة', 'الاعتماد', 'الإغلاق'];
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(request.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text('${request.id} • ${request.date}'), const SizedBox(height: 12), Chip(label: Text(request.status.label), backgroundColor: request.status.color.withValues(alpha: .12), labelStyle: TextStyle(color: request.status.color))]))),
        const SectionTitle('مسار الطلب'),
        ...List.generate(steps.length, (i) => ListTile(leading: CircleAvatar(radius: 14, backgroundColor: i < 3 ? Brand.green : Colors.black12, child: Icon(i < 3 ? Icons.check : Icons.circle, size: 14, color: Colors.white)), title: Text(steps[i]), subtitle: Text(i < 3 ? 'تم' : 'بانتظار الإجراء'))),
        if (request.notes.isNotEmpty) ...[const SectionTitle('الملاحظات'), Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(request.notes)))],
      ]),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: 'الجدول الدراسي', children: [
        const SectionTitle('الأحد'),
        ...studentCourses.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: Icons.schedule_rounded, title: c.name, subtitle: '${c.time} • ${c.room}\n${c.instructor}'))),
        const SectionTitle('الثلاثاء'),
        ...studentCourses.take(2).map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: Icons.schedule_rounded, title: c.name, subtitle: '${c.time} • ${c.room}'))),
      ]);
}

class StudentCoursePage extends StatelessWidget {
  final CourseItem course;
  const StudentCoursePage({required this.course, super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: course.name, children: [
        InfoRow(icon: Icons.tag_rounded, title: 'رمز المساق', subtitle: course.code),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.person_rounded, title: 'المحاضر', subtitle: course.instructor),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.room_rounded, title: 'القاعة والوقت', subtitle: '${course.room} • ${course.time}'),
        const SectionTitle('أدائي'),
        LinearProgressIndicator(value: course.attendance / 100, minHeight: 12, borderRadius: BorderRadius.circular(10)),
        const SizedBox(height: 6),
        Text('الحضور ${course.attendance.toInt()}%'),
        const SizedBox(height: 18),
        LinearProgressIndicator(value: course.grade / 100, minHeight: 12, borderRadius: BorderRadius.circular(10), color: Brand.green),
        const SizedBox(height: 6),
        Text('العلامة الحالية ${course.grade.toInt()}%'),
      ]);
}

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: 'العلامات', children: [
        const Row(children: [Expanded(child: MetricCard('3.41', 'المعدل التراكمي', Icons.auto_graph_rounded, Color(0xFFEAF4FF))), SizedBox(width: 10), Expanded(child: MetricCard('96/132', 'الساعات المنجزة', Icons.school_rounded, Color(0xFFECF8E8)))]),
        const SectionTitle('الفصل الحالي'),
        ...studentCourses.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: Icons.grade_rounded, title: c.name, subtitle: '${c.code} • ${c.grade.toInt()} / 100', trailing: Text('${c.grade.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: Brand.blue))))),
      ]);
}

class AcademicPlanPage extends StatelessWidget {
  const AcademicPlanPage({super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: 'الخطة الدراسية', children: [
        const Text('نسبة الإنجاز', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        LinearProgressIndicator(value: 96 / 132, minHeight: 14, borderRadius: BorderRadius.circular(10)),
        const SizedBox(height: 8),
        const Text('96 من 132 ساعة — 73%'),
        const SectionTitle('المتطلبات'),
        const InfoRow(icon: Icons.check_circle_rounded, title: 'متطلبات الجامعة', subtitle: '24/24 ساعة مكتملة'),
        const SizedBox(height: 10),
        const InfoRow(icon: Icons.check_circle_rounded, title: 'متطلبات الكلية', subtitle: '30/30 ساعة مكتملة'),
        const SizedBox(height: 10),
        const InfoRow(icon: Icons.timelapse_rounded, title: 'متطلبات التخصص', subtitle: '42/66 ساعة مكتملة'),
        const SizedBox(height: 10),
        const InfoRow(icon: Icons.radio_button_unchecked_rounded, title: 'مساقات متبقية', subtitle: '36 ساعة'),
      ]);
}

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(
        title: 'الحضور والغياب',
        children: studentCourses
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: c.attendance / 100,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 6),
                        Text('نسبة الحضور: ${c.attendance.toInt()}% • الغياب: ${(20 * (1 - c.attendance / 100)).round()} محاضرة'),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
}

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});
  @override
  Widget build(BuildContext context) => const GenericListPage(title: 'الامتحانات', children: [
        InfoRow(icon: Icons.quiz_rounded, title: 'تصميم UX/UI — امتحان نصفي', subtitle: '03/10/2026 • 10:00 • القاعة A201'),
        SizedBox(height: 10),
        InfoRow(icon: Icons.quiz_rounded, title: 'قواعد البيانات — Quiz 2', subtitle: '06/10/2026 • 12:00 • LAB 1'),
        SizedBox(height: 10),
        InfoRow(icon: Icons.quiz_rounded, title: 'الذكاء الاصطناعي — امتحان نصفي', subtitle: '09/10/2026 • 11:00 • القاعة B104'),
      ]);
}

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: 'الخدمات المالية', children: [
        const Row(children: [Expanded(child: MetricCard('1,250 ₪', 'المطلوب', Icons.payments_rounded, Color(0xFFFFF2E7))), SizedBox(width: 10), Expanded(child: MetricCard('3,400 ₪', 'المدفوع', Icons.check_circle_rounded, Color(0xFFECF8E8)))]),
        const SectionTitle('الحركات المالية'),
        const InfoRow(icon: Icons.receipt_long_rounded, title: 'دفعة رسوم دراسية', subtitle: '20/09/2026 • 500 ₪'),
        const SizedBox(height: 10),
        const InfoRow(icon: Icons.receipt_long_rounded, title: 'رسوم تسجيل', subtitle: '15/09/2026 • 100 ₪'),
        const SectionTitle('خدمات'),
        InfoRow(icon: Icons.download_rounded, title: 'تحميل كشف الحساب', subtitle: 'PDF', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم ربط تنزيل PDF مع النظام المالي')))),
      ]);
}

class DigitalIdPage extends StatelessWidget {
  const DigitalIdPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('البطاقة الجامعية الرقمية')),
      body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Card(child: Container(width: 360, padding: const EdgeInsets.all(24), decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Colors.white, Color(0xFFEAF4FF)])), child: Column(mainAxisSize: MainAxisSize.min, children: [Image.asset('assets/images/ucas_logo.png', height: 90), const CircleAvatar(radius: 44, backgroundColor: Brand.softBlue, child: Icon(Icons.person_rounded, size: 54, color: Brand.blue)), const SizedBox(height: 12), Text(state.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), Text(state.userId), Text(state.department), const SizedBox(height: 18), Container(width: 150, height: 150, color: Colors.white, alignment: Alignment.center, child: const Icon(Icons.qr_code_2_rounded, size: 130, color: Brand.charcoal)), const SizedBox(height: 10), const Text('امسح الرمز للتحقق من هوية الطالب', style: TextStyle(color: Colors.black54))]))))),
    );
  }
}
