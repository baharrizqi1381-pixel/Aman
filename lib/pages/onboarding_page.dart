import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/alarm_service.dart';
import '../services/notification_service.dart';
import 'main_menu_page.dart';

enum Difficulty { easy, medium, hard }

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _nickController = TextEditingController();
  Difficulty _diff = Difficulty.easy;
  List<TextEditingController> optionalControllers = List.generate(5, (_) => TextEditingController());

  @override
  void dispose() {
    _nickController.dispose();
    for (var c in optionalControllers) c.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', _nickController.text.trim());
    await prefs.setString('difficulty', _diff.toString());
    await prefs.setStringList('optionals', optionalControllers.map((c) => c.text.trim()).toList());
    if (!prefs.containsKey('exp')) await prefs.setInt('exp', 0);
    if (!prefs.containsKey('level')) await prefs.setInt('level', 0);
    // schedule alarm & notification
    AlarmService.startDailyAlarm();
    await NotificationService().scheduleDailyFiveAM();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainMenuPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Awal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Masukkan nickname', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextField(controller: _nickController, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Nickname')),
          const SizedBox(height: 16),
          const Text('Pilih level tugas wajib', style: TextStyle(fontSize: 16)),
          RadioListTile(value: Difficulty.easy, groupValue: _diff, title: const Text('Easy'), onChanged: (v) => setState(() => _diff = v!)),
          RadioListTile(value: Difficulty.medium, groupValue: _diff, title: const Text('Medium'), onChanged: (v) => setState(() => _diff = v!)),
          RadioListTile(value: Difficulty.hard, groupValue: _diff, title: const Text('Hard'), onChanged: (v) => setState(() => _diff = v!)),
          const SizedBox(height: 16),
          const Text('Tugas opsional (5 slot - kamu bisa isi sendiri)', style: TextStyle(fontSize: 16)),
          ...List.generate(5, (i) => Padding(padding: const EdgeInsets.only(top: 8), child: TextField(controller: optionalControllers[i], decoration: InputDecoration(labelText: 'Tugas opsional #\${i+1}', border: const OutlineInputBorder())))),
          const SizedBox(height: 20),
          Center(child: ElevatedButton(child: const Text('Simpan & Lanjut'), onPressed: _saveAndContinue)),
        ]),
      ),
    );
  }
}
