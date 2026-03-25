import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/views/auth/login/custom_text_field.dart';
import 'package:fyp_therapy/core/widgets/primary_button.dart';
import '../../../core/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final Color themeColor = widget.role == 'Patient'
        ? AppColors.primary
        : AppColors.therapistPrimary;

    return Scaffold(
      backgroundColor: themeColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 150),
                // const SizedBox(height: 0),

                // Main Form Container
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                        "Log in",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email Field
                      _buildLabel("Email Address"),
                      CustomTextField(
                        hint: "Enter your Email Address",
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      _buildLabel("Password"),
                      CustomTextField(
                        hint: "Check Password",
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.toNamed(
                            AppRoutes.forgotPassword,
                            arguments: widget.role,
                          ),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Login Button
                      Obx(() {
                        final bool isLoading = authController.isLoading.value;
                        return PrimaryButton(
                          text: isLoading ? "Please wait..." : "Login",
                          backgroundColor: themeColor,
                          onPressed: () {
                            if (isLoading) return;
                            authController.updateCredentials(
                              email: emailController.text,
                              password: passwordController.text,
                              role: widget.role,
                            );
                            authController.handleLogin();
                          },
                        );
                      }),

                      const SizedBox(height: 30),

                      // Social Logins
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              "Facebook",
                              FontAwesomeIcons.facebook,
                              Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildSocialButton(
                              "Google",
                              FontAwesomeIcons.google,
                              Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Signup Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(
                              AppRoutes.signup,
                              arguments: widget.role,
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, Color iconColor) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
