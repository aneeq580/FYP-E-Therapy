import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController is registered globally in main.dart for app-wide access.
    // Keep this binding safe in case routes still declare AuthBinding.
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
  }
}
