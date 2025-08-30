import 'package:flutter/material.dart';
import 'pages/onboarding_page.dart';
import 'pages/main_menu_page.dart';
import 'services/alarm_service.dart';
import 'services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize timezone data for notifications
  tz.initializeTimeZones();
  await NotificationService().init();
  await AlarmService.init(); // initialize alarm manager
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solo Leveling Habit Game',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const StarterRouter(),
    );
  }
}

class StarterRouter extends StatefulWidget {
  const StarterRouter({super.key});
  @override
  State<StarterRouter> createState() => _StarterRouterState();
}

class _StarterRouterState extends State<StarterRouter> {
  bool _hasOnboard = false;

  @override
  void initState() {
    super.initState();
    _checkOnboard();
  }

  Future<void> _checkOnboard() async {
    final present = await StorageService.hasOnboard();
    setState(() { _hasOnboard = present; });
    if (!present) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingPage()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainMenuPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

// StorageService is a minimal facade implemented below to avoid extra imports in this lightweight sample.
class StorageService {
  static Future<bool> hasOnboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('nickname');
    } catch (e) {
      return false;
    }
  }
}

// To keep this single-file small, import SharedPreferences here
import 'package:shared_preferences/shared_preferences.dart';
