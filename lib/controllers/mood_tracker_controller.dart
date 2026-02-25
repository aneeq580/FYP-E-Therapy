import 'package:get/get.dart';

/// Controller for Mood Tracker screen.
class MoodTrackerController extends GetxController {
  final selectedMood = RxnString();

  void setMood(String mood) {
    selectedMood.value = mood;
  }
}

