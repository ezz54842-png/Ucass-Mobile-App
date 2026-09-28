import 'package:flutter/material.dart';
import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'common.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الموظف')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        BrandedHeader(name: state.name, subtitle: 'موظف • ${state.department}'),
        const SizedBox(height: 14),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.7, mainAxisSpacing: 10, crossAxisSpacing: 10, children: const [
          MetricCard('17', 'طلبات واردة', Icons.inbox_rounded, Color(0xFFEAF4FF)),
          MetricCard('8', 'قيد المعالجة', Icons.hourglass_top_rounded, Color(0xFFFFF2E7)),
          MetricCard('4', 'مهام اليوم', Icons.task_alt_rounded, Color(0xFFF2ECFF)),
          MetricCard('12', 'إجازات متبقية', Icons.beach_access_rounded, Color(0xFFECF8E8)),
        ]),
        const SectionTitle('الخدمات السريعة'),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 8, children: [
          QuickAction(label: 'الحضور', icon: Icons.fingerprint_rounded, color: Brand.blue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeAttendancePage()))),
          QuickAction(label: 'إجازة', icon: Icons.beach_access_rounded, color: Colors.green, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestPage()))),
          QuickAction(label: 'الراتب', icon: Icons.payments_rounded, color: Colors.orange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollPage()))),
          QuickAction(label: 'المستندات', icon: Icons.folder_rounded, color: Colors.deepPurple, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeDocumentsPage()))),
        ]),
        const SectionTitle('المهام الحالية'),
        ...state.tasks.take(3).map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: t.done ? Icons.check_circle_rounded : Icons.pending_actions_rounded, title: t.title, subtitle: 'الأولوية: ${t.priority} • ${t.done ? 'مكتملة' : 'قيد التنفيذ'}'))),
        const SectionTitle('خدمات أخرى'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ActionChip(avatar: const Icon(Icons.event_available_rounded, size: 18), label: const Text('حجز موعد'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentsPage()))),
          ActionChip(avatar: const Icon(Icons.support_agent_rounded, size: 18), label: const Text('الدعم الفني'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()))),
        ]),
      ]),
    );
  }
}

class IncomingRequestsPage extends StatelessWidget {
  const IncomingRequestsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('الطلبات الواردة')),
      body: ListView.separated(padding: const EdgeInsets.all(16), itemCount: state.requests.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) { final r = state.requests[i]; return Card(child: ListTile(leading: CircleAvatar(backgroundColor: r.status.color.withValues(alpha: .12), child: Icon(Icons.description_rounded, color: r.status.color)), title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('${r.id} • ${r.category}\n${r.status.label}'), isThreeLine: true, trailing: PopupMenuButton<RequestStatus>(onSelected: (s) => state.updateRequest(r, s), itemBuilder: (_) => [const PopupMenuItem(value: RequestStatus.review, child: Text('بدء المراجعة')), const PopupMenuItem(value: RequestStatus.approved, child: Text('اعتماد')), const PopupMenuItem(value: RequestStatus.needsEdit, child: Text('إرجاع للتعديل')), const PopupMenuItem(value: RequestStatus.completed, child: Text('إكمال')), const PopupMenuItem(value: RequestStatus.rejected, child: Text('رفض'))]))); }),
    );
  }
}

class EmployeeTasksPage extends StatelessWidget {
  const EmployeeTasksPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('مهامي')),
      body: ListView.separated(padding: const EdgeInsets.all(16), itemCount: state.tasks.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) { final t = state.tasks[i]; return Card(child: CheckboxListTile(value: t.done, onChanged: (_) => state.toggleTask(t), title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('الأولوية: ${t.priority}'))); }),
    );
  }
}

class EmployeeAttendancePage extends StatelessWidget {
  const EmployeeAttendancePage({super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: 'الحضور والانصراف', children: const [
        Row(children: [Expanded(child: MetricCard('08:03', 'وقت الدخول', Icons.login_rounded, Color(0xFFECF8E8))), SizedBox(width: 10), Expanded(child: MetricCard('15:02', 'وقت الخروج', Icons.logout_rounded, Color(0xFFEAF4FF)))]),
        SectionTitle('سجل هذا الشهر'),
        InfoRow(icon: Icons.check_circle_rounded, title: 'الأحد 27/09', subtitle: '08:01 - 15:00 • 6:59 ساعة'),
        SizedBox(height: 10),
        InfoRow(icon: Icons.check_circle_rounded, title: 'السبت 26/09', subtitle: '08:05 - 15:04 • 6:59 ساعة'),
      ]);
}

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});
  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  String type = 'سنوية';
  final from = TextEditingController(text: '01/10/2026');
  final to = TextEditingController(text: '02/10/2026');
  final reason = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('طلب إجازة')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          DropdownButtonFormField<String>(value: type, decoration: const InputDecoration(labelText: 'نوع الإجازة'), items: ['سنوية', 'مرضية', 'طارئة'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => type = v!)),
          const SizedBox(height: 12),
          TextField(controller: from, decoration: const InputDecoration(labelText: 'من تاريخ')),
          const SizedBox(height: 12),
          TextField(controller: to, decoration: const InputDecoration(labelText: 'إلى تاريخ')),
          const SizedBox(height: 12),
          TextField(controller: reason, maxLines: 4, decoration: const InputDecoration(labelText: 'السبب')),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت محاكاة إضافة المرفق'))), icon: const Icon(Icons.attach_file_rounded), label: const Text('إضافة مرفق')),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلب الإجازة'))), icon: const Icon(Icons.send_rounded), label: const Text('إرسال الطلب')),
        ]),
      );
}

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});
  @override
  Widget build(BuildContext context) => GenericListPage(title: 'كشف الراتب', children: [
        const Row(children: [Expanded(child: MetricCard('2,800 ₪', 'الراتب الأساسي', Icons.account_balance_wallet_rounded, Color(0xFFEAF4FF))), SizedBox(width: 10), Expanded(child: MetricCard('2,950 ₪', 'صافي الراتب', Icons.payments_rounded, Color(0xFFECF8E8)))]),
        const SectionTitle('تفاصيل سبتمبر 2026'),
        const InfoRow(icon: Icons.add_circle_rounded, title: 'العلاوات', subtitle: '300 ₪'),
        const SizedBox(height: 10),
        const InfoRow(icon: Icons.remove_circle_rounded, title: 'الخصومات', subtitle: '150 ₪'),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم ربط تنزيل كشف الراتب PDF بنظام الموارد البشرية'))), icon: const Icon(Icons.download_rounded), label: const Text('تحميل كشف الراتب PDF')),
      ]);
}

class EmployeeDocumentsPage extends StatelessWidget {
  const EmployeeDocumentsPage({super.key});
  @override
  Widget build(BuildContext context) => const GenericListPage(title: 'مستنداتي', children: [
        InfoRow(icon: Icons.description_rounded, title: 'قرار التعيين', subtitle: 'PDF • 2024'),
        SizedBox(height: 10),
        InfoRow(icon: Icons.description_rounded, title: 'كتاب تكليف', subtitle: 'PDF • سبتمبر 2026'),
        SizedBox(height: 10),
        InfoRow(icon: Icons.description_rounded, title: 'تعريف راتب', subtitle: 'PDF • سبتمبر 2026'),
      ]);
}
