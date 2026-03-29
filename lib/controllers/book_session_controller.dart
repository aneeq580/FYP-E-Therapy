import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/availability_model.dart';
import '../services/therapist_service.dart';
import 'package:intl/intl.dart';

/// Controller for Book Session flow (therapist, date & time selection).
class BookSessionController extends GetxController {
  final TherapistService _therapistService = Get.find<TherapistService>();

  final selectedTherapistData = Rxn<Map<String, dynamic>>();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final selectedDuration = Rxn<int>(); // minutes

  final therapistAvailability = Rxn<AvailabilityModel>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      setTherapist(Get.arguments as Map<String, dynamic>);
    }
  }

  bool get isBookingValid =>
      selectedTherapistData.value != null &&
      selectedDate.value != null &&
      selectedTime.value != null &&
      selectedDuration.value != null &&
      isTimeAvailable(selectedDate.value!, selectedTime.value!);

  Future<void> setTherapist(Map<String, dynamic> therapist) async {
    selectedTherapistData.value = therapist;
    selectedDate.value = null;
    selectedTime.value = null; // Clear previous selections

    final uid = therapist['uid'] as String?;
    if (uid != null) {
      therapistAvailability.value = await _therapistService.getAvailability(uid);
      
      // Auto-select the first available date so slots are visible immediately
      if (therapistAvailability.value != null && 
          therapistAvailability.value!.weeklyAvailability.isNotEmpty) {
        DateTime current = DateTime.now();
        for (int i = 0; i < 7; i++) {
          if (isDayAvailable(current)) {
            setDate(current);
            break;
          }
          current = current.add(const Duration(days: 1));
        }
      }
    } else {
      therapistAvailability.value = null;
    }
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    // reset time if date changes as availability might differ
    selectedTime.value = null;
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void setDuration(int minutes) {
    selectedDuration.value = minutes;
  }

  bool isDayAvailable(DateTime date) {
    if (therapistAvailability.value == null) return true; // Default if not set
    final dayName = DateFormat('EEEE').format(date);
    return therapistAvailability.value!.weeklyAvailability.containsKey(dayName);
  }

  bool isTimeAvailable(DateTime date, TimeOfDay time) {
    if (therapistAvailability.value == null) return true;
    final dayName = DateFormat('EEEE').format(date);
    final slots = therapistAvailability.value!.weeklyAvailability[dayName];
    if (slots == null) return false;

    final selectedTotalMinutes = time.hour * 60 + time.minute;

    for (var slot in slots) {
      final startParts = slot.start.split(':');
      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endParts = slot.end.split(':');
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      if (selectedTotalMinutes >= startMinutes && selectedTotalMinutes <= endMinutes) {
        return true;
      }
    }
    return false;
  }

  List<TimeOfDay> getAvailableSlots(DateTime date) {
    if (therapistAvailability.value == null) return [];
    final dayName = DateFormat('EEEE').format(date);
    final slots = therapistAvailability.value!.weeklyAvailability[dayName];
    if (slots == null) return [];

    List<TimeOfDay> allSlots = [];
    for (var slot in slots) {
      final startParts = slot.start.split(':');
      final startHour = int.parse(startParts[0]);
      final startMinute = int.parse(startParts[1]);
      
      final endParts = slot.end.split(':');
      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);

      var current = TimeOfDay(hour: startHour, minute: startMinute);
      final totalMinutesEnd = endHour * 60 + endMinute;

      // Use the selected duration to determine slot spacing
      // Default to 60 if not set
      final int step = (selectedDuration.value ?? 0) > 0 ? selectedDuration.value! : 60;

      while (current.hour * 60 + current.minute + step <= totalMinutesEnd) {
        allSlots.add(current);
        
        int totalMinutesNext = current.hour * 60 + current.minute + step;
        if (totalMinutesNext >= 1440) break; // End of day

        current = TimeOfDay(hour: totalMinutesNext ~/ 60, minute: totalMinutesNext % 60);
      }
    }
    return allSlots;
  }

  String getWorkingHoursSummary(DateTime date) {
    if (therapistAvailability.value == null) return "";
    final dayName = DateFormat('EEEE').format(date);
    final slots = therapistAvailability.value!.weeklyAvailability[dayName];
    if (slots == null || slots.isEmpty) return "Unavailable";

    return slots.map((s) => "${s.start} - ${s.end}").join(", ");
  }
}

