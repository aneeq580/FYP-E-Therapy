import 'package:flutter/material.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_button.dart';
import 'login_screen.dart';

/// Sign Up Screen
///
/// Allows new users to create an account
/// Features:
/// - Full name input
/// - Email input
/// - Password input with visibility toggle
/// - Confirm password input
/// - Create account button
/// - Navigation link to login
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool isLoading = false;
  bool agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

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
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF2C3E50),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 24),

                // Welcome title
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  'Join us for better mental health support',
                  style: TextStyle(fontSize: 16, color: Color(0xFF5A6B7E)),
                ),
                const SizedBox(height: 40),

                // Full Name field
                AuthTextField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: fullNameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

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
                  hintText: 'Create a password',
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 16),

                // Confirm Password field
                AuthTextField(
                  label: 'Confirm Password',
                  hintText: 'Confirm your password',
                  controller: confirmPasswordController,
                  isPassword: true,
                ),
                const SizedBox(height: 24),

                // Terms agreement checkbox
                Row(
                  children: [
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          agreedToTerms = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF7B68C0),
                      side: const BorderSide(
                        color: Color(0xFFE0E6ED),
                        width: 1.5,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to the ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5A6B7E),
                          ),
                          children: const [
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7B68C0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Create Account button
                AuthButton(
                  label: 'Create Account',
                  isLoading: isLoading,
                  onPressed: agreedToTerms
                      ? () {
                          // TODO: Implement signup logic
                          setState(() {
                            isLoading = true;
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      : () {}, // Disable if terms not agreed
                ),
                const SizedBox(height: 24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF5A6B7E)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log In',
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
