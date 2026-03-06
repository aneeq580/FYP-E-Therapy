import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/therapist_card.dart';

import '../../services/therapist_service.dart';

/// Therapists Screen - Therapist discovery and listing
class TherapistListScreen extends StatelessWidget {
  const TherapistListScreen({
    super.key,
    this.selectedTherapist,
    this.selectedDate,
    this.selectedTime,
    this.isSelectionMode = false,
  });

  final String? selectedTherapist;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final bool isSelectionMode;

  void _handleViewProfile(String therapistName) {
    Get.snackbar(
      'Coming Soon',
      'Profile view for $therapistName is currently under development.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.background,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(AppSizes.spacingMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TherapistService>()) {
      Get.put(TherapistService());
    }
    final therapistService = Get.find<TherapistService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Therapists'),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: therapistService.getTherapistsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading therapists: ${snapshot.error}'),
            );
          }

          final therapists = snapshot.data ?? [];

          if (therapists.isEmpty) {
            return const Center(child: Text('No therapists available yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingMedium,
            ),
            itemCount: therapists.length,
            itemBuilder: (context, index) {
              final therapist = therapists[index];
              return InkWell(
                onTap: () {
                  if (isSelectionMode) {
                    Get.back(result: therapist);
                  } else {
                    _handleViewProfile(
                      therapist['fullName'] as String? ?? 'Therapist',
                    );
                  }
                },
                child: TherapistCard(
                  name:
                      therapist['fullName'] as String? ??
                      therapist['name'] as String? ??
                      'Therapist',
                  specialty:
                      therapist['specialty'] as String? ?? 'General Therapist',
                  rating: (therapist['rating'] as num?)?.toDouble() ?? 5.0,
                  photoUrl:
                      therapist['profileImageUrl'] as String? ??
                      therapist['photoUrl'] as String?,
                  onViewProfile: () => _handleViewProfile(
                    therapist['fullName'] as String? ?? 'Therapist',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
