import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/services/auth_service.dart';

class SplashController extends GetxController {
  // Pre-fetched destination route — populated in background while user reads onboarding
  String? _destinationRoute;

  @override
  void onInit() {
    super.onInit();
    _prefetchDestination();
  }

  Future<void> _prefetchDestination() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _destinationRoute = AppRoutes.roleSelection;
      return;
    }

    try {
      final authService = Get.find<AuthService>();
      final role = await authService.fetchUserRole(user.uid);
      _destinationRoute =
          (role == 'therapist') ? AppRoutes.therapistHome : AppRoutes.patientHome;
    } catch (_) {
      _destinationRoute = AppRoutes.roleSelection;
    }
  }

  /// Called when user taps "Get Started" or "Skip"
  void navigate() {
    final route = _destinationRoute ?? AppRoutes.roleSelection;
    Get.offAllNamed(route);
  }
}
