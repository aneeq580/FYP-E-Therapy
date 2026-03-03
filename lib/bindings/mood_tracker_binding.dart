import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/mood_tracker_controller.dart';
import 'package:fyp_therapy/services/mood_service.dart';

class MoodTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodService>(() => MoodService());
    Get.lazyPut<MoodTrackerController>(() => MoodTrackerController());
  }
}

