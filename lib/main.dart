import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_therapy/firebase_options.dart';
import 'package:fyp_therapy/services/appointment_service.dart';
import 'package:fyp_therapy/services/chat_service.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import 'core/constants/colors.dart';
import 'services/auth_service.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthService(), permanent: true);
  Get.put(AppointmentService(), permanent: true);
  Get.put(ChatService(), permanent: true);
  // Ensure AuthController is available app-wide for screens that call Get.find<AuthController>()
  Get.put(AuthController(), permanent: true);

  // Decide initial route based on Firebase auth persistence.
  final User? user = FirebaseAuth.instance.currentUser;
  String initialRoute = AppRoutes.roleSelection;

  if (user != null) {
    try {
      final authService = Get.find<AuthService>();
      final role = await authService.fetchUserRole(user.uid);
      if (role == 'therapist') {
        initialRoute = AppRoutes.therapistHome;
      } else {
        initialRoute = AppRoutes.patientHome;
      }
    } catch (e) {
      initialRoute = AppRoutes.patientHome; // Fallback
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Therapy App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
