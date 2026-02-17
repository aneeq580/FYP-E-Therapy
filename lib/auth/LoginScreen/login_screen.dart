import 'package:flutter/material.dart';
import 'package:fyp_therapy/navigation/app_routes.dart';
import 'widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Dummy credentials - Patient
  static const String patientEmail = 'patient@therapy.com';
  static const String patientPassword = 'patient123';

  // Dummy credentials - Therapist
  static const String therapistEmail = 'therapist@therapy.com';
  static const String therapistPassword = 'therapist123';

  void _handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate credentials based on role
    bool isValidCredential = false;
    String currentRole = widget.role.toLowerCase();

    print('Login Debug:');
    print('Role: $currentRole');
    print('Email: $email');
    print('Password: $password');

    if (currentRole == 'patient') {
      isValidCredential =
          (email == patientEmail && password == patientPassword);
      print('Checking Patient - Valid: $isValidCredential');
    } else if (currentRole == 'therapist') {
      isValidCredential =
          (email == therapistEmail && password == therapistPassword);
      print('Checking Therapist - Valid: $isValidCredential');
    } else {
      print('Unknown role: $currentRole');
    }

    if (isValidCredential) {
      // Navigate to appropriate home screen based on role
      if (currentRole == 'patient') {
        print('Navigating to Patient Home');
        AppRoutes.navigateReplacementTo(context, AppRoutes.patientHome);
      } else if (currentRole == 'therapist') {
        print('Navigating to Therapist Home');
        AppRoutes.navigateReplacementTo(context, AppRoutes.therapistHome);
      }
    } else {
      // Show error message
      print('Login failed - showing error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🔥 Center Icon
                const Icon(
                  Icons.self_improvement,
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
                  icon: Icons.email_outlined,
                  controller: emailController,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  hint: "Password",
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  isPassword: true,
                ),

                const SizedBox(height: 35),

                /// 🔥 Bigger Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: PrimaryButton(text: "Login", onPressed: _handleLogin),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    AppRoutes.navigateTo(
                      context,
                      AppRoutes.signup,
                      arguments: widget.role,
                    );
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
