import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});
  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  String nickname = '';
  int exp = 0;
  int level = 0;
  List<String> optionals = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nickname = prefs.getString('nickname') ?? '';
      exp = prefs.getInt('exp') ?? 0;
      level = prefs.getInt('level') ?? 0;
      optionals = prefs.getStringList('optionals') ?? List.filled(5, '');
    });
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) return '00:00:00';
    String two(int n) => n.toString().padLeft(2, '0');
    return '\${two(d.inHours)}:\${two(d.inMinutes.remainder(60))}:\${two(d.inSeconds.remainder(60))}';
  }

  Duration _countdownToFive() {
    final now = DateTime.now();
    DateTime next5 = DateTime(now.year, now.month, now.day, 5, 0);
    if (now.isAfter(next5) || now.isAtSameMomentAs(next5)) next5 = next5.add(const Duration(days: 1));
    return next5.difference(now);
  }

  @override
  Widget build(BuildContext context) {
    final countdown = _countdownToFive();
    return Scaffold(
      appBar: AppBar(title: Text('Halo, \$nickname - Level \$level (Exp: \$exp)')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(child: ListTile(title: const Text('Countdown ke 05:00'), subtitle: Text(_formatDuration(countdown)), trailing: ElevatedButton(child: const Text('Mulai'), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Game akan dimulai pada pukul 05:00.'))); }))),
          const SizedBox(height: 12),
          const Text('Jadwal hari ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // For brevity, only showing placeholders; full schedule generation should be implemented per difficulty.
          Card(child: ListTile(title: const Text('Lari 1 KM'), subtitle: const Text('Waktu: 06:00'), trailing: ElevatedButton(child: const Text('Selesai'), onPressed: () async { final prefs = await SharedPreferences.getInstance(); await prefs.setInt('exp', (prefs.getInt('exp') ?? 0) + 10); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tugas selesai, +10 EXP'))); }))),
          const SizedBox(height: 8),
          const Text('Tugas opsional', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...List.generate(optionals.length, (i) {
            final txt = optionals[i];
            return Card(child: ListTile(title: Text(txt.isEmpty ? 'Kosong' : txt), trailing: ElevatedButton(child: const Text('Mulai 1 jam'), onPressed: () async { final prefs = await SharedPreferences.getInstance(); await prefs.setInt('exp', (prefs.getInt('exp') ?? 0) + 20); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tugas opsional selesai, +20 EXP (simulasi)'))); })));
          }),
        ]),
      ),
    );
  }
}
