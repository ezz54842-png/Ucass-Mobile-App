import 'package:flutter/material.dart';
import 'theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;
  const SectionTitle(this.title, {this.action, this.onTap, super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
          if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
        ]),
      );
}

class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color tint;
  const MetricCard(this.value, this.label, this.icon, this.tint, {super.key});
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(backgroundColor: tint, child: Icon(icon, color: Brand.blue)),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ]),
        ),
      );
}

class QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const QuickAction({required this.label, required this.icon, required this.color, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Brand.border)),
          child: Column(children: [CircleAvatar(backgroundColor: color.withValues(alpha: .12), child: Icon(icon, color: color)), const SizedBox(height: 8), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))]),
        ),
      );
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  const InfoRow({required this.icon, required this.title, required this.subtitle, this.onTap, this.trailing, super.key});
  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(backgroundColor: Brand.softBlue, child: Icon(icon, color: Brand.blue)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(subtitle),
          trailing: trailing ?? (onTap == null ? null : const Icon(Icons.chevron_left_rounded)),
        ),
      );
}

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const EmptyState(this.title, this.subtitle, this.icon, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(children: [Icon(icon, size: 64, color: Colors.black26), const SizedBox(height: 12), Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 6), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54))]),
      );
}

class BrandedHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  const BrandedHeader({required this.name, required this.subtitle, super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Brand.blue, Color(0xFF2C86D2)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(children: [
          const CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.person_rounded, color: Brand.blue, size: 32)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مرحباً، $name', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: Colors.white70))])),
          Image.asset('assets/images/ucas_logo.png', height: 54, width: 54, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.school, color: Colors.white, size: 40)),
        ]),
      );
}
