import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/therapist_selection_card.dart';
import '../../core/widgets/datetime_selection_card.dart';

/// Book Session Screen - Booking flow for therapy sessions
class BookSessionScreen extends StatelessWidget {
  const BookSessionScreen({super.key});

  void _handleTherapistSelection() {
    // TODO: Navigate to therapist selection screen
    // Navigator.push(context, ...);
  }

  void _handleDateSelection() {
    // TODO: Show date picker
    // showDatePicker(...);
  }

  void _handleTimeSelection() {
    // TODO: Show time picker
    // showTimePicker(...);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Session'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spacingLarge),

            // Page Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: Text(
                'Book Your Session',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spacingSmall),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: Text(
                'Select your therapist and preferred date & time',
                style: AppTextStyles.bodyTextSecondary.copyWith(
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spacingLarge),

            // Therapist Selection Card
            TherapistSelectionCard(
              onTap: _handleTherapistSelection,
            ),

            const SizedBox(height: AppSizes.spacingMedium),

            // Date & Time Selection Card
            DateTimeSelectionCard(
              onDateTap: _handleDateSelection,
              onTimeTap: _handleTimeSelection,
            ),

            const SizedBox(height: AppSizes.spacingLarge),

            // Confirm Booking Button (Disabled)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null, // Disabled UI
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.5),
                    foregroundColor: AppColors.textOnPrimary.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spacingLarge),
          ],
        ),
      ),
    );
  }
}
