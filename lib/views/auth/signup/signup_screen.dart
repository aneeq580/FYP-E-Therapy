import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/views/auth/signup/custom_text_field.dart';
import 'package:fyp_therapy/core/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  final String role;

  const SignupScreen({super.key, required this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  /// 🔥 Center Icon
                  const FaIcon(
                    FontAwesomeIcons.handHoldingHeart,
                    size: 70,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Create ${widget.role} Account",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Full Name Field
                  CustomTextField(
                    hint: "Full Name",
                    icon: FontAwesomeIcons.user,
                    controller: fullNameController,
                  ),

                  const SizedBox(height: 20),

                  /// Email Field
                  CustomTextField(
                    hint: "Email",
                    icon: FontAwesomeIcons.envelope,
                    controller: emailController,
                  ),

                  const SizedBox(height: 20),

                  /// Password Field
                  CustomTextField(
                    hint: "Password",
                    icon: FontAwesomeIcons.lock,
                    controller: passwordController,
                    isPassword: true,
                  ),

                  const SizedBox(height: 20),

                  /// Confirm Password Field
                  CustomTextField(
                    hint: "Confirm Password",
                    icon: FontAwesomeIcons.lock,
                    controller: confirmPasswordController,
                    isPassword: true,
                  ),

                  const SizedBox(height: 35),

                  Obx(() {
                    final bool disabled = authController.isLoading.value;
                    return PrimaryButton(
                      text: disabled ? "Please wait..." : "Sign Up",
                      onPressed: () {
                        if (disabled) return;
                        if (passwordController.text.trim() !=
                            confirmPasswordController.text.trim()) {
                          Get.snackbar(
                            'Error',
                            'Passwords do not match',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        authController.updateCredentials(
                          email: emailController.text,
                          password: passwordController.text,
                          role: widget.role,
                        );
                        authController.handleSignup();
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Get.offNamed(AppRoutes.login, arguments: widget.role);
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
