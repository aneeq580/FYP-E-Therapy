import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';

/// Controller responsible for login/auth-related logic.
class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final role = ''.obs;

  // Dummy credentials - Patient
  static const String patientEmail = 'patient@therapy.com';
  static const String patientPassword = 'patient123';

  // Dummy credentials - Therapist
  static const String therapistEmail = 'therapist@therapy.com';
  static const String therapistPassword = 'therapist123';

  void updateCredentials({
    required String email,
    required String password,
    required String role,
  }) {
    this.email.value = email.trim();
    this.password.value = password.trim();
    this.role.value = role.toLowerCase();
  }

  /// Handles login based on current role and credentials.
  /// Keeps the same behavior and navigation as the previous implementation.
  void handleLogin() {
    final currentEmail = email.value;
    final currentPassword = password.value;
    final currentRole = role.value;

    // Validate credentials based on role
    bool isValidCredential = false;

    print('Login Debug:');
    print('Role: $currentRole');
    print('Email: $currentEmail');
    print('Password: $currentPassword');

    if (currentRole == 'patient') {
      isValidCredential =
          (currentEmail == patientEmail && currentPassword == patientPassword);
      print('Checking Patient - Valid: $isValidCredential');
    } else if (currentRole == 'therapist') {
      isValidCredential = (currentEmail == therapistEmail &&
          currentPassword == therapistPassword);
      print('Checking Therapist - Valid: $isValidCredential');
    } else {
      print('Unknown role: $currentRole');
    }

    if (isValidCredential) {
      // Navigate to appropriate home screen based on role
      if (currentRole == 'patient') {
        print('Navigating to Patient Home');
        Get.offNamed(AppRoutes.patientHome);
      } else if (currentRole == 'therapist') {
        print('Navigating to Therapist Home');
        Get.offNamed(AppRoutes.therapistHome);
      }
    } else {
      // Show error message
      print('Login failed - showing error');
      final ctx = Get.context;
      if (ctx != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

