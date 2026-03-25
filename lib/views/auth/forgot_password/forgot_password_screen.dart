import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fyp_therapy/views/auth/login/custom_text_field.dart';
import 'package:fyp_therapy/core/widgets/primary_button.dart';
import '../../../core/constants/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email is required',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // TODO: Replace with real password reset logic (e.g. Firebase Auth).
    Get.snackbar(
      'Success',
      'Password reset link sent (demo)',
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String role = Get.arguments as String? ?? 'Patient';
    final Color themeColor = role == 'Patient'
        ? AppColors.primary
        : AppColors.therapistPrimary;

    final String illustration = role == 'Patient'
        ? 'assets/images/doctor.png'
        : 'assets/images/therapist.png';

    return Scaffold(
      backgroundColor: themeColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Illustration
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Image.asset(
                    illustration,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),

                // Main Form Container
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 350,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter your email to reset your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 40),

                      // Email Field
                      _buildLabel("Email Address"),
                      CustomTextField(
                        hint: "Enter your Email Address",
                        controller: emailController,
                      ),
                      const SizedBox(height: 35),

                      // Submit Button
                      PrimaryButton(
                        text: 'Send Reset Link',
                        backgroundColor: themeColor,
                        onPressed: _handleSubmit,
                      ),
                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
