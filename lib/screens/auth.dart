import 'package:flutter/material.dart';
import '../models.dart';
import '../state.dart';
import '../theme.dart';
import 'shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final state = AppStateScope.of(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => state.loggedIn ? const AppShell() : const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.white, Color(0xFFEAF4FF), Color(0xFFF0FAE9)]),
          ),
          child: SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset('assets/images/ucas_logo.png', height: 170, fit: BoxFit.contain),
              const SizedBox(height: 22),
              const Text('تطبيق الخدمات الجامعية', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Brand.charcoal)),
              const SizedBox(height: 8),
              const Text('كل خدمات الطلبة والمدرسين والموظفين في مكان واحد', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 38),
              const CircularProgressIndicator(color: Brand.blue),
            ]),
          ),
        ),
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final user = TextEditingController(text: '20260001');
  final pass = TextEditingController(text: '123456');
  UserRole role = UserRole.student;
  bool loading = false;
  bool obscure = true;

  Future<void> submit() async {
    setState(() => loading = true);
    try {
      await AppStateScope.of(context).login(user.text, pass.text, role);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 24),
              Image.asset('assets/images/ucas_logo.png', height: 125, fit: BoxFit.contain),
              const SizedBox(height: 24),
              const Text('مرحباً بك مجدداً', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Brand.blue)),
              const SizedBox(height: 6),
              const Text('سجّل الدخول للوصول إلى خدماتك الجامعية', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 28),
              DropdownButtonFormField<UserRole>(
                value: role,
                decoration: const InputDecoration(labelText: 'نوع الحساب', prefixIcon: Icon(Icons.badge_rounded)),
                items: UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
                onChanged: (v) => setState(() => role = v ?? UserRole.student),
              ),
              const SizedBox(height: 14),
              TextField(controller: user, decoration: const InputDecoration(labelText: 'الرقم الجامعي / الوظيفي', prefixIcon: Icon(Icons.person_outline_rounded))),
              const SizedBox(height: 14),
              TextField(
                controller: pass,
                obscureText: obscure,
                decoration: InputDecoration(labelText: 'كلمة المرور', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_off : Icons.visibility))),
              ),
              Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم إرسال رابط الاستعادة عبر البريد الجامعي'))), child: const Text('نسيت كلمة المرور؟'))),
              const SizedBox(height: 8),
              FilledButton.icon(onPressed: loading ? null : submit, icon: loading ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.login_rounded), label: const Text('تسجيل الدخول')),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: submit, icon: const Icon(Icons.school_rounded), label: const Text('الدخول عبر حساب الجامعة')),
              const SizedBox(height: 24),
              const Text('نسخة تجريبية عملية — غيّر نوع الحساب لمعاينة تجربة الطالب أو المدرس أو الموظف.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black45, fontSize: 12)),
            ],
          ),
        ),
      );
}
