import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/services/auth_service.dart';
import 'package:fyp_therapy/services/storage_service.dart';

class SplashController extends GetxController {
  // Pre-fetched destination route — populated in background while user reads onboarding
  String? _destinationRoute;

  final RxBool showOnboarding = false.obs;

  @override
  void onInit() {
    super.onInit();
    _prefetchDestination();
  }

  Future<void> _prefetchDestination() async {
    final storageService = Get.find<StorageService>();
    final stopwatch = Stopwatch()..start();
    
    final hasSeenOnboarding = await storageService.hasSeenOnboarding();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _destinationRoute = AppRoutes.roleSelection;
    } else {
      try {
        final authService = Get.find<AuthService>();
        final role = await authService.fetchUserRole(user.uid);
        _destinationRoute = (role == 'therapist')
            ? AppRoutes.therapistHome
            : AppRoutes.patientHome;
      } catch (_) {
        _destinationRoute = AppRoutes.roleSelection;
      }
    }

    // Ensure splash screen lasts at least 2 seconds
    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed < 2000) {
      await Future.delayed(Duration(milliseconds: 2000 - elapsed));
    }

    if (hasSeenOnboarding) {
      Get.offAllNamed(_destinationRoute!);
    } else {
      showOnboarding.value = true;
    }
  }

  /// Called when user taps "Get Started" or "Skip"
  Future<void> navigate() async {
    final route = _destinationRoute ?? AppRoutes.roleSelection;
    await Get.find<StorageService>().setOnboardingSeen();
    Get.offAllNamed(route);
  }
}
