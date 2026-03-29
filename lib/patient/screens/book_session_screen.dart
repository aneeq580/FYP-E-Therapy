import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/book_session_controller.dart';
import 'package:fyp_therapy/patient/screens/therapist_list_screen.dart';
import 'package:fyp_therapy/models/appointment_model.dart';
import 'package:fyp_therapy/controllers/appointment_controller.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/patient/profile/patient_profile_controller.dart';
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
      () => const TherapistListScreen(isSelectionMode: true),
    );

    if (result != null) {
      controller.setTherapist(result);
    }
  }

  /// Date Picker
  Future<void> _handleDateSelection(BuildContext context) async {
    if (controller.therapistAvailability.value != null && 
        controller.therapistAvailability.value!.weeklyAvailability.isEmpty) {
      Get.snackbar(
        'Unavailable',
        'This therapist has not set any working hours.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    DateTime initial = controller.selectedDate.value ?? DateTime.now();
    // Ensure initial is selectable (search up to 7 days ahead)
    while (!controller.isDayAvailable(initial)) {
      initial = initial.add(const Duration(days: 1));
      if (initial.difference(DateTime.now()).inDays > 8) {
        initial = DateTime.now();
        break;
      }
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      selectableDayPredicate: (DateTime day) => controller.isDayAvailable(day),
    );

    if (pickedDate != null) {
      controller.setDate(pickedDate);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final appointmentController = Get.find<AppointmentController>();

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
                selectedTherapist:
                    therapist?['fullName'] as String? ??
                    therapist?['name'] as String?,
                selectedTherapistSpecialty: therapist?['specialty'] as String?,
                profileImageUrl:
                    therapist?['profileImageUrl'] as String? ??
                    therapist?['photoUrl'] as String?,
              ),

              const SizedBox(height: 12),

              /// Date & Time Selection
              DateTimeSelectionCard(
                onDateTap: () => _handleDateSelection(context),
                onTimeTap: () {}, // Not needed anymore as chips are below
                selectedDate: date,
                selectedTime: time,
                hideTime: true, // I'll add this flag to DateTimeSelectionCard or just handle it
              ),
              
              const SizedBox(height: 16),

              /// Available Time Slots
              if (date != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Available Times",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final summary = controller.getWorkingHoursSummary(date);
                        return Text(
                          "Therapist is set: $summary",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      Obx(() {
                        final slots = controller.getAvailableSlots(date);
                        if (slots.isEmpty) {
                          return const Text(
                            "No available slots for this day.",
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          );
                        }
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: slots.map((s) {
                            final isSelected = time?.hour == s.hour && time?.minute == s.minute;
                            return GestureDetector(
                              onTap: () => controller.setTime(s),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? AppColors.primary.withOpacity(0.12) 
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected 
                                        ? AppColors.primary 
                                        : Colors.grey.shade200,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  _formatTime(s),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 12),

              /// Duration Selection
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: Row(
                  children: [
                    const Text('Duration:'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final choice = await showDialog<int>(
                            context: context,
                            builder: (ctx) {
                              return SimpleDialog(
                                title: const Text('Select duration'),
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(ctx, 30),
                                    child: const Text('30 minutes'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(ctx, 45),
                                    child: const Text('45 minutes'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(ctx, 60),
                                    child: const Text('60 minutes'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (choice != null) {
                            controller.setDuration(choice);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(() {
                            final dur = controller.selectedDuration.value;
                            return Text(
                              dur != null ? '$dur mins' : 'Select duration',
                              style: TextStyle(
                                color: dur != null
                                    ? AppColors.textPrimary
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
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
                            final patientUser =
                                Get.find<AuthController>().currentUser.value!;

                            final duration = controller.selectedDuration.value!;
                            final endDateTime = sessionDateTime.add(
                              Duration(minutes: duration),
                            );

                            final newAppointment = AppointmentModel(
                              id: '', // Firestore auto generates
                              patientId: patientUser.uid,
                              patientName: Get.find<PatientProfileController>()
                                  .displayName,
                              therapistId:
                                  selectedTherapist['uid'] as String? ??
                                  'unknown_therapist',
                              therapistName:
                                  selectedTherapist['fullName'] as String? ??
                                  selectedTherapist['name'] as String? ??
                                  'Therapist',
                              date: Timestamp.fromDate(sessionDateTime),
                              duration: duration,
                              endTime: Timestamp.fromDate(endDateTime),
                              status: 'pending',
                            );

                            appointmentController.bookAppointment(
                              newAppointment,
                            );

                            Get.offNamed(AppRoutes.mySessions);
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
              color: isComplete
                  ? AppColors.primary
                  : AppColors.textLight.withOpacity(0.15),
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
