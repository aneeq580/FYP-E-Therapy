import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/views/auth/role_selection/role_card.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _navigate(BuildContext context, String role) {
    Get.toNamed(AppRoutes.login, arguments: role);
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
                const Spacer(),

                const FaIcon(
                  FontAwesomeIcons.handHoldingHeart,
                  size: 70,
                  color: Colors.white,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Choose how you want to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),

                const SizedBox(height: 50),

                RoleCard(
                  title: "Continue as Therapist",
                  icon: FontAwesomeIcons.brain,
                  onTap: () => _navigate(context, "Therapist"),
                ),

                const SizedBox(height: 20),

                RoleCard(
                  title: "Continue as Patient",
                  icon: FontAwesomeIcons.heart,
                  onTap: () => _navigate(context, "Patient"),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
