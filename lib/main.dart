import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp_therapy/firebase_options.dart';
import 'package:fyp_therapy/services/appointment_service.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import 'core/constants/colors.dart';
import 'services/auth_service.dart';
import 'services/therapist_service.dart';
import 'services/storage_service.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize essential services
  Get.put(AuthService(), permanent: true);
  Get.put(AppointmentService(), permanent: true);
  Get.put(TherapistService(), permanent: true);
  Get.put(StorageService(), permanent: true);
  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          surface: AppColors.background,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.primaryLight,
          disabledColor: AppColors.backgroundLight,
          selectedColor: AppColors.secondary,
          secondarySelectedColor: AppColors.secondaryLight,
          labelStyle: const TextStyle(color: AppColors.textOnPrimary),
          secondaryLabelStyle: const TextStyle(color: AppColors.textOnPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          showCheckmark: false,
          brightness: Brightness.light,
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
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
