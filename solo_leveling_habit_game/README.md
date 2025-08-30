# SoloLevelingHabitGame (Flutter) - Starter Project

Ini adalah starter project Flutter untuk game interaktif ala Solo Leveling.
Struktur ringan disediakan sehingga kamu bisa langsung meng-upload ke GitHub dan build di Codemagic.

**Isi:**
- pubspec.yaml
- lib/
  - main.dart (entry point)
  - pages/
    - onboarding_page.dart
    - main_menu_page.dart
  - services/
    - alarm_service.dart
    - notification_service.dart
    - storage_service.dart
- android/
  - app/src/main/AndroidManifest.xml (permissions untuk alarm)
- .codemagic.yaml

**Catatan penting:**
- Untuk alarm yang benar-benar membangunkan perangkat dan kebijakan Do Not Disturb, kamu perlu menambahkan permission dan pengaturan native lebih lanjut di Android (contoh permission sudah ada di AndroidManifest.xml).
- Jangan lupa melakukan `flutter pub get` setelah meng-clone repo, dan sesuaikan konfigurasi `flutter_local_notifications` untuk Android (channel & timezone initialization).

Build with Codemagic: .codemagic.yaml sudah disertakan.
