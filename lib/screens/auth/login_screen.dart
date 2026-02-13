import 'package:flutter/material.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_button.dart';
import 'signup_screen.dart';

/// Login Screen
///
/// Allows users to log in with email and password
/// Features:
/// - Email input field
/// - Password input field with visibility toggle
/// - Login button
/// - Navigation link to sign up
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF2C3E50),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Welcome title
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  'Log in to your account',
                  style: TextStyle(fontSize: 16, color: Color(0xFF5A6B7E)),
                ),
                const SizedBox(height: 40),

                // Email field
                AuthTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password field
                AuthTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 12),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Navigate to forgot password screen
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7B68C0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Login button
                AuthButton(
                  label: 'Login',
                  isLoading: isLoading,
                  onPressed: () {
                    // TODO: Implement login logic
                    setState(() {
                      isLoading = true;
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Divider text
                const Center(
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A6B7E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 14, color: Color(0xFF5A6B7E)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7B68C0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
