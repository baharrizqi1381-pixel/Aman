// Minimal wrapper if you want to expand storage logic
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveNickname(String nick) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', nick);
  }
}
