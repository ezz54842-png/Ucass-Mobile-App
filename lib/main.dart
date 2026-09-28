import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth.dart';
import 'state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(UniversityServicesApp(appState: AppState(prefs)));
}

class UniversityServicesApp extends StatelessWidget {
  final AppState appState;
  const UniversityServicesApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UCAS Services',
        theme: buildTheme(),
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
        home: const SplashScreen(),
      ),
    );
  }
}
