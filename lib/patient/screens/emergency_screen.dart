import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp_therapy/core/widgets/patient_app_bar.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/emergency_action_card.dart';

/// Emergency Screen - Provides emergency help and support options
class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  // Soft orange/red accent colors for emergency (calming, not harsh)
  static const Color softEmergencyRed = Color(0xFFFF7043); // Soft orange-red
  static const Color softEmergencyOrange = Color(0xFFFF8A65); // Softer orange
  static const Color softEmergencyPink = Color(
    0xFFFFAB91,
  ); // Very soft pink-orange

  void _handleCallEmergency() {
    // TODO: Implement emergency call functionality
    // launch('tel:911'); or similar
  }

  void _handleContactTherapist() {
    // TODO: Navigate to therapist contact or chat
    // Navigator.push(context, ...);
  }

  void _handleHelplineInfo() {
    // TODO: Show helpline information dialog or screen
    // showDialog(...);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Emergency'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spacingLarge),

            // Calm Warning Message
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              padding: const EdgeInsets.all(AppSizes.spacingLarge),
              decoration: BoxDecoration(
                color: softEmergencyOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: softEmergencyOrange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.infoCircle, color: softEmergencyRed, size: 28),
                  const SizedBox(width: AppSizes.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You\'re not alone',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Help is available. Reach out to someone you trust or use the options below.',
                          style: AppTextStyles.bodyTextSecondary.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingLarge),

            // Call Emergency Card
            EmergencyActionCard(
              icon: FontAwesomeIcons.phone,
              title: 'Call Emergency',
              subtitle: 'Dial 911 for immediate emergency assistance',
              backgroundColor: softEmergencyRed.withOpacity(0.1),
              iconColor: softEmergencyRed,
              onTap: _handleCallEmergency,
            ),

            // Contact Therapist Card
            EmergencyActionCard(
              icon: FontAwesomeIcons.userDoctor,
              title: 'Contact Therapist',
              subtitle: 'Reach out to your assigned therapist for support',
              backgroundColor: softEmergencyOrange.withOpacity(0.1),
              iconColor: softEmergencyOrange,
              onTap: _handleContactTherapist,
            ),

            // Helpline Info Card
            EmergencyActionCard(
              icon: FontAwesomeIcons.infoCircle,
              title: 'Helpline Info',
              subtitle: 'View crisis helpline numbers and resources',
              backgroundColor: softEmergencyPink.withOpacity(0.1),
              iconColor: softEmergencyPink,
              onTap: _handleHelplineInfo,
            ),

            const SizedBox(height: AppSizes.spacingLarge),
          ],
        ),
      ),
    );
  }
}
