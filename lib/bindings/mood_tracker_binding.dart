import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/mood_tracker_controller.dart';

class MoodTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodTrackerController>(() => MoodTrackerController());
  }
}

