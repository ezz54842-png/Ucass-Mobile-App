import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات'), actions: [TextButton(onPressed: state.markNotificationsRead, child: const Text('تحديد كمقروء'))]),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final n = state.notifications[i];
          return Card(
            color: n.read ? Colors.white : const Color(0xFFF1F7FF),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Brand.softBlue, child: Icon(n.icon, color: Brand.blue)),
              title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${n.body}\n${n.time}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BrandedHeader(name: state.name, subtitle: '${state.role.label} • ${state.department}'),
          const SizedBox(height: 16),
          InfoRow(icon: Icons.badge_rounded, title: 'الرقم الجامعي / الوظيفي', subtitle: state.userId),
          const SizedBox(height: 10),
          const InfoRow(icon: Icons.mail_rounded, title: 'البريد الجامعي', subtitle: 'user@ucas.edu.ps'),
          const SizedBox(height: 10),
          const InfoRow(icon: Icons.phone_rounded, title: 'رقم الهاتف', subtitle: '0599 000 000'),
          const SizedBox(height: 10),
          InfoRow(icon: Icons.translate_rounded, title: 'اللغة', subtitle: 'العربية', onTap: () {}),
          const SizedBox(height: 10),
          InfoRow(icon: Icons.lock_rounded, title: 'تغيير كلمة المرور', subtitle: 'تحديث بيانات الدخول', onTap: () => _simpleDialog(context, 'تغيير كلمة المرور', 'تم تجهيز شاشة تغيير كلمة المرور للربط مع النظام المركزي.')),
          const SizedBox(height: 10),
          InfoRow(icon: Icons.privacy_tip_rounded, title: 'الخصوصية والأمان', subtitle: 'إعدادات الحساب والجلسات', onTap: () => _simpleDialog(context, 'الخصوصية والأمان', 'يمكن ربط هذه الشاشة بسياسات الجامعة ونظام المصادقة.')),
          const SizedBox(height: 20),
          FilledButton.tonalIcon(
            onPressed: () async {
              await state.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

void _simpleDialog(BuildContext context, String title, String message) {
  showDialog(context: context, builder: (_) => AlertDialog(title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))]));
}

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الإعلانات الجامعية')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: announcementsSeed.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final a = announcementsSeed[i];
            return InfoRow(icon: Icons.campaign_rounded, title: a.title, subtitle: '${a.source} • ${a.date}', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnnouncementDetailsPage(item: a))));
          },
        ),
      );
}

class AnnouncementDetailsPage extends StatelessWidget {
  final AnnouncementItem item;
  const AnnouncementDetailsPage({required this.item, super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الإعلان')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const Icon(Icons.campaign_rounded, size: 72, color: Brand.blue),
          const SizedBox(height: 16),
          Text(item.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('${item.source} • ${item.date}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 24),
          Text(item.body, style: const TextStyle(fontSize: 17, height: 1.7)),
        ]),
      );
}

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});
  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  String department = 'القبول والتسجيل';
  final date = TextEditingController(text: '30/09/2026');
  String time = '10:00';
  final reason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('حجز المواعيد')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        DropdownButtonFormField<String>(value: department, decoration: const InputDecoration(labelText: 'القسم'), items: ['القبول والتسجيل', 'الدائرة المالية', 'شؤون الطلبة', 'القسم الأكاديمي'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => department = v!)),
        const SizedBox(height: 12),
        TextField(controller: date, decoration: const InputDecoration(labelText: 'التاريخ', prefixIcon: Icon(Icons.calendar_month_rounded))),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: time, decoration: const InputDecoration(labelText: 'الوقت'), items: ['09:00', '10:00', '11:00', '12:00', '13:00'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => time = v!)),
        const SizedBox(height: 12),
        TextField(controller: reason, maxLines: 3, decoration: const InputDecoration(labelText: 'سبب الزيارة')),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () { state.addAppointment(department, date.text, time, reason.text); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حجز الموعد بنجاح'))); }, icon: const Icon(Icons.check_circle_rounded), label: const Text('تأكيد الحجز')),
        const SectionTitle('مواعيدي'),
        if (state.appointments.isEmpty) const EmptyState('لا توجد مواعيد', 'المواعيد التي تحجزها ستظهر هنا.', Icons.event_busy_rounded),
        ...state.appointments.map((a) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: Icons.event_available_rounded, title: a.department, subtitle: '${a.date} • ${a.time}\n${a.reason}'))),
      ]),
    );
  }
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final title = TextEditingController();
  String department = 'الدعم الفني';
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('الدعم والتذاكر')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const SectionTitle('فتح تذكرة جديدة'),
        DropdownButtonFormField<String>(value: department, decoration: const InputDecoration(labelText: 'الجهة'), items: ['الدعم الفني', 'القبول والتسجيل', 'الدائرة المالية', 'شؤون الطلبة'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => department = v!)),
        const SizedBox(height: 12),
        TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان المشكلة')),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () { if (title.text.trim().isEmpty) return; state.addTicket(title.text.trim(), department); title.clear(); }, icon: const Icon(Icons.add_rounded), label: const Text('إرسال التذكرة')),
        const SectionTitle('تذاكري'),
        ...state.tickets.map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: InfoRow(icon: Icons.confirmation_number_rounded, title: t.title, subtitle: '${t.id} • ${t.department} • ${switch (t.status) { TicketStatus.open => 'مفتوحة', TicketStatus.processing => 'قيد المعالجة', TicketStatus.closed => 'مغلقة' }}'))),
      ]),
    );
  }
}

class GenericListPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const GenericListPage({required this.title, required this.children, super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(16), children: children));
}
