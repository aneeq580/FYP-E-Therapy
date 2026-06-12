import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/services/auth_service.dart';
import 'package:fyp_therapy/services/storage_service.dart';
import 'package:fyp_therapy/chat/controllers/ai_chat_controller.dart';

/// Controller responsible for auth flow & UI state on top of [AuthService].
class AuthController extends GetxController {
  AuthController()
    : _authService = Get.find<AuthService>(),
      _storageService = Get.find<StorageService>();

  final AuthService _authService;
  final StorageService _storageService;

  final email = ''.obs;
  final password = ''.obs;
  final role = ''.obs; // 'patient' or 'therapist'
  final fullName = ''.obs;
  final phone = ''.obs;
  final degreeDocumentUrl = ''.obs;

  /// Global loading flag used by Login / Signup buttons.
  final isLoading = false.obs;

  /// Expose current Firebase user reactively.
  Rxn<User> get currentUser => _authService.currentUser;

  void updateCredentials({
    required String email,
    required String password,
    required String role,
  }) {
    this.email.value = email.trim();
    this.password.value = password.trim();
    this.role.value = role.toLowerCase();
  }

  void updatePersonalDetails({
    required String firstName,
    required String lastName,
    required String phoneNum,
    String? degreePath,
  }) {
    fullName.value = '${firstName.trim()} ${lastName.trim()}'.trim();
    phone.value = phoneNum.trim();
    if (degreePath != null) {
      degreeDocumentUrl.value = degreePath.trim();
    }
  }

  Future<void> handleLogin() async {
    final currentEmail = email.value;
    final currentPassword = password.value;
    final currentRole = role.value;

    if (currentEmail.isEmpty || currentPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email: currentEmail,
        password: currentPassword,
      );

      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user returned from sign-in',
        );
      }

      // Verify stored role in Firestore (if available).
      final storedRole = await _authService.fetchUserRole(user.uid);
      if (storedRole != null && storedRole != currentRole.toLowerCase()) {
        // Role mismatch: sign out and show error.
        await _authService.signOut();
        Get.snackbar(
          'Role mismatch',
          'This account is registered as "$storedRole". Please login using the correct role.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Navigate to appropriate home screen based on role.
      final resolvedRole = storedRole ?? currentRole;
      if (resolvedRole == 'therapist') {
        Get.offAllNamed(AppRoutes.therapistHome);
      } else {
        // Default to patient home if role is unknown or 'patient'.
        Get.offAllNamed(AppRoutes.patientHome);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login failed',
        _mapFirebaseError(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      Get.snackbar(
        'Login failed',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleSignup() async {
    final currentEmail = email.value;
    final currentPassword = password.value;
    final currentRole = role.value;

    if (currentEmail.isEmpty || currentPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      print('Starting signup for $currentEmail as $currentRole'); // debug

      final credential = await _authService.signUpWithEmailAndPassword(
        email: currentEmail,
        password: currentPassword,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('No user returned after signup');
      }

      print('User created: ${user.uid}'); // debug

      // For therapists, mark that they submitted degree (without storing file in Firebase)
      final hasDegreeSubmission =
          currentRole == 'therapist' && degreeDocumentUrl.value.isNotEmpty;

      // Firestore write with initial profile info.
      await _authService.createUserRecord(
        uid: user.uid,
        email: currentEmail,
        role: currentRole.toLowerCase(),
        fullName: fullName.value.isNotEmpty ? fullName.value : null,
        phone: phone.value.isNotEmpty ? phone.value : null,
        degreeSubmitted: hasDegreeSubmission,
        joinedAt: DateTime.now(),
      );

      // Also update FirebaseAuth display name for convenience.
      if (fullName.value.isNotEmpty) {
        await user.updateDisplayName(fullName.value);
      }

      print('Firestore record created for ${user.uid}'); // debug

      // Navigation
      print('Navigating based on role: $currentRole');

      if (currentRole == 'therapist') {
        Get.offAllNamed(AppRoutes.therapistHome);
      } else {
        // For patients, force initial profile completion by going first
        // to the profile screen with a flag.
        Get.offAllNamed(
          AppRoutes.patientProfile,
          arguments: {
            'requireCompletion': true,
            'initialName': fullName.value,
            'initialEmail': currentEmail,
          },
        );
      }

      print('Navigation called successfully'); // debug
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      Get.snackbar(
        'Signup failed',
        _mapFirebaseError(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      print('Unexpected error during signup:');
      print('Error: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        'Signup failed',
        'Error: ${e.toString().split('\n').first}', // pehli line hi dikhao, lambi na ho
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[800],
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleLogout() async {
    try {
      await _authService.signOut();
      // Fully delete AI chat controller on logout so the next user
      // always gets a fresh instance bound to their own UID.
      if (Get.isRegistered<AiChatController>()) {
        Get.delete<AiChatController>(force: true);
      }
      Get.offAllNamed(AppRoutes.roleSelection);
    } catch (_) {
      Get.snackbar(
        'Logout failed',
        'Unable to log out at the moment.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger one.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Authentication error (${e.code}). Please try again.';
    }
  }
}
