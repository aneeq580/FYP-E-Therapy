import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/views/auth/login/custom_text_field.dart';
import 'package:fyp_therapy/core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF23BBB7), Color(0xFF23627C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🔥 Center Icon
                const FaIcon(
                  FontAwesomeIcons.handHoldingHeart,
                  size: 70,
                  color: Colors.white,
                ),

                const SizedBox(height: 20),
                Text(
                  "${widget.role} Login",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                CustomTextField(
                  hint: "Email",
                  icon: FontAwesomeIcons.envelope,
                  controller: emailController,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  hint: "Password",
                  icon: FontAwesomeIcons.lock,
                  controller: passwordController,
                  isPassword: true,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// 🔥 Bigger Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: Obx(() {
                    final bool disabled = authController.isLoading.value;
                    return PrimaryButton(
                      text: disabled ? "Please wait..." : "Login",
                      onPressed: () {
                        if (disabled) return;
                        authController.updateCredentials(
                          email: emailController.text,
                          password: passwordController.text,
                          role: widget.role,
                        );
                        authController.handleLogin();
                      },
                    );
                  }),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.signup, arguments: widget.role);
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
