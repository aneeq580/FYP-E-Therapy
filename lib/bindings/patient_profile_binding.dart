import 'package:get/get.dart';
import '../controllers/patient_activity_controller.dart';

/// Lazily injects [PatientActivityController] when the patient profile
/// route is loaded.
class PatientProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientActivityController>(() => PatientActivityController());
  }
}
