import 'package:get/get.dart';
import 'package:fyp_therapy/services/auth_service.dart';

class TherapistPatientDetailController extends GetxController {
  TherapistPatientDetailController() : _authService = Get.find<AuthService>();

  final AuthService _authService;
  final isLoading = false.obs;
  final profile = Rxn<Map<String, dynamic>>();

  Future<void> loadProfile(String uid) async {
    isLoading.value = true;
    try {
      profile.value = await _authService.fetchUserProfile(uid);
    } finally {
      isLoading.value = false;
    }
  }
}
