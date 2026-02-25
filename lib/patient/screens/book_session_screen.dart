import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/book_session_controller.dart';
import 'package:fyp_therapy/patient/screens/therapist_list_screen.dart';
import 'package:fyp_therapy/models/session_model.dart';
import 'package:fyp_therapy/services/session_service.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/therapist_selection_card.dart';
import '../../core/widgets/datetime_selection_card.dart';

class BookSessionScreen extends GetView<BookSessionController> {
  const BookSessionScreen({super.key});

  /// Therapist Selection
  Future<void> _handleTherapistSelection() async {
    final result = await Get.to<Map<String, dynamic>>(
      () => const TherapistListScreen(),
    );

    if (result != null) {
      controller.setTherapist(result);
    }
  }

  /// Date Picker
  Future<void> _handleDateSelection(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      controller.setDate(pickedDate);
    }
  }

  /// Time Picker
  Future<void> _handleTimeSelection(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      controller.setTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionService = Get.find<SessionService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Book Session'),
      body: Obx(() {
        final therapist = controller.selectedTherapistData.value;
        final date = controller.selectedDate.value;
        final time = controller.selectedTime.value;
        final isBookingValid = controller.isBookingValid;

        return SingleChildScrollView(
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
                    _buildCompactStep('Therapist', therapist != null),
                    _buildCompactStep('Date', date != null),
                    _buildCompactStep('Time', time != null),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Therapist Selection
              TherapistSelectionCard(
                onTap: _handleTherapistSelection,
                selectedTherapist: therapist?['name'] as String?,
                selectedTherapistSpecialty: therapist?['specialty'] as String?,
                profileImageUrl: therapist?['photoUrl'] as String?,
              ),

              const SizedBox(height: 12),

              /// Date & Time Selection
              DateTimeSelectionCard(
                onDateTap: () => _handleDateSelection(context),
                onTimeTap: () => _handleTimeSelection(context),
                selectedDate: date,
                selectedTime: time,
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
                            final selectedTherapist =
                                controller.selectedTherapistData.value!;
                            final selectedDate = controller.selectedDate.value!;
                            final selectedTime = controller.selectedTime.value!;

                            final sessionDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );

                            final newSession = SessionModel(
                              id: DateTime.now().microsecondsSinceEpoch
                                  .toString(),
                              patientId: currentPatientId,
                              patientName:
                                  'Alex Johnson', // TODO: Replace with logged-in patient name from Firebase
                              therapistId:
                                  currentTherapistId, // TODO: Replace with selected therapist ID from Firestore
                              therapistName:
                                  selectedTherapist['name'] as String? ??
                                  'Therapist',
                              sessionDateTime: sessionDateTime,
                              sessionType:
                                  'Online video', // TODO: Make this selectable in UI
                              status: SessionStatus.pending,
                              reason: null,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );

                            sessionService.bookSession(newSession);

                            Get.toNamed(AppRoutes.mySessions);
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
                      isBookingValid
                          ? 'Confirm Booking'
                          : 'Complete all fields',
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
        );
      }),
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
