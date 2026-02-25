import 'package:get/get.dart';

/// Controller for Settings screen (UI-only toggles for now).
class SettingsController extends GetxController {
  final isDarkMode = false.obs;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }
}

