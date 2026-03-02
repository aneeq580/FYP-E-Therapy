import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for Book Session flow (therapist, date & time selection).
class BookSessionController extends GetxController {
  final selectedTherapistData = Rxn<Map<String, dynamic>>();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final selectedDuration = Rxn<int>(); // minutes

  bool get isBookingValid =>
      selectedTherapistData.value != null &&
      selectedDate.value != null &&
      selectedTime.value != null &&
      selectedDuration.value != null;

  void setTherapist(Map<String, dynamic> therapist) {
    selectedTherapistData.value = therapist;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void setDuration(int minutes) {
    selectedDuration.value = minutes;
  }}

