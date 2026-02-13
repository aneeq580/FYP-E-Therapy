import 'package:flutter/material.dart';
import 'widgets/role_card.dart';
import 'widgets/auth_button.dart';
import 'login_screen.dart';

/// Role Selection Screen
///
/// Displays app logo and allows users to select their role:
/// - Patient: seeking therapy services
/// - Therapist: providing therapy services
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole; // Track selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                // Logo (placeholder)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7B68C0),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Continue as',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  'Select your role to get started',
                  style: TextStyle(fontSize: 16, color: Color(0xFF5A6B7E)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Patient Role Card
                RoleCard(
                  roleName: 'Patient',
                  icon: Icons.favorite,
                  description: 'Seeking therapy\nand mental health support',
                  isSelected: selectedRole == 'patient',
                  onTap: () {
                    setState(() {
                      selectedRole = 'patient';
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Therapist Role Card
                RoleCard(
                  roleName: 'Therapist',
                  icon: Icons.school,
                  description: 'Providing professional\ntherapy services',
                  isSelected: selectedRole == 'therapist',
                  onTap: () {
                    setState(() {
                      selectedRole = 'therapist';
                    });
                  },
                ),
                const SizedBox(height: 48),

                // Continue Button
                AuthButton(
                  label: 'Continue',
                  isLoading: false,
                  onPressed: selectedRole == null
                      ? () {} // Disable if no role selected
                      : () {
                          // Navigate to login screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
