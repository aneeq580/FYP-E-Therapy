import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp_therapy/patient/screens/therapist_list_screen.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/therapist_selection_card.dart';
import '../../core/widgets/datetime_selection_card.dart';

class BookSessionScreen extends StatefulWidget {
  const BookSessionScreen({super.key});

  @override
  State<BookSessionScreen> createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  Map<String, dynamic>? selectedTherapistData;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool get isBookingValid =>
      selectedTherapistData != null &&
      selectedDate != null &&
      selectedTime != null;

  /// Therapist Selection
  Future<void> _handleTherapistSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TherapistListScreen()),
    );

    if (result != null) {
      setState(() {
        selectedTherapistData = result as Map<String, dynamic>;
      });
    }
  }

  /// Date Picker
  Future<void> _handleDateSelection() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  /// Time Picker
  Future<void> _handleTimeSelection() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Book Session'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            /// Title & Subtitle Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Your Session',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose therapist, date, and time',
                    style: AppTextStyles.bodyTextSecondary.copyWith(
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Step Indicator - Compact version
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCompactStep('Therapist', selectedTherapistData != null),
                  _buildCompactStep('Date', selectedDate != null),
                  _buildCompactStep('Time', selectedTime != null),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Therapist Selection
            TherapistSelectionCard(
              onTap: _handleTherapistSelection,
              selectedTherapist: selectedTherapistData?['name'] as String?,
              selectedTherapistSpecialty:
                  selectedTherapistData?['specialty'] as String?,
              profileImageUrl: selectedTherapistData?['photoUrl'] as String?,
            ),

            const SizedBox(height: 12),

            /// Date & Time Selection
            DateTimeSelectionCard(
              onDateTap: _handleDateSelection,
              onTimeTap: _handleTimeSelection,
              selectedDate: selectedDate,
              selectedTime: selectedTime,
            ),

            const SizedBox(height: 24),

            /// Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isBookingValid
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Session Booked Successfully 🎉"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBookingValid
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.4),
                    foregroundColor: AppColors.textOnPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isBookingValid ? 3 : 0,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  child: Text(
                    isBookingValid ? 'Confirm Booking' : 'Complete all fields',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Info Footer
            if (!isBookingValid)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.infoCircle,
                        color: AppColors.secondary,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Select all fields to confirm',
                          style: AppTextStyles.bodyTextSecondary.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStep(String label, bool isComplete) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isComplete
                    ? [AppColors.secondary, AppColors.primary]
                    : [
                        AppColors.textLight.withOpacity(0.15),
                        AppColors.textLight.withOpacity(0.1),
                      ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                isComplete ? FontAwesomeIcons.check : FontAwesomeIcons.circle,
                color: isComplete ? Colors.white : AppColors.textLight,
                size: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isComplete
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
