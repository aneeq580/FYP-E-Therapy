import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/availability_model.dart';
import '../../services/therapist_service.dart';

class AvailabilityController extends GetxController {
  final TherapistService _therapistService = Get.find<TherapistService>();
  final _auth = FirebaseAuth.instance;

  final Rx<AvailabilityModel> currentAvailability = AvailabilityModel.defaultAvailability().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAvailability();
  }

  Future<void> loadAvailability() async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final avail = await _therapistService.getAvailability(uid);
        if (avail != null) {
          currentAvailability.value = avail;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load availability: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleDay(String day) {
    var avail = currentAvailability.value.weeklyAvailability;
    if (avail.containsKey(day)) {
      avail.remove(day);
    } else {
      avail[day] = [TimeSlot(start: '09:00', end: '17:00')];
    }
    currentAvailability.refresh();
  }

  void addSlot(String day) {
    var avail = currentAvailability.value.weeklyAvailability;
    if (avail.containsKey(day)) {
      avail[day]!.add(TimeSlot(start: '09:00', end: '17:00'));
      currentAvailability.refresh();
    }
  }

  void removeSlot(String day, int index) {
    var avail = currentAvailability.value.weeklyAvailability;
    if (avail.containsKey(day) && avail[day]!.length > index) {
      avail[day]!.removeAt(index);
      if (avail[day]!.isEmpty) {
        avail.remove(day);
      }
      currentAvailability.refresh();
    }
  }

  void updateSlotTime(String day, int index, {String? start, String? end}) {
    var avail = currentAvailability.value.weeklyAvailability;
    if (avail.containsKey(day) && avail[day]!.length > index) {
      final oldSlot = avail[day]![index];
      avail[day]![index] = TimeSlot(
        start: start ?? oldSlot.start,
        end: end ?? oldSlot.end,
      );
      currentAvailability.refresh();
    }
  }

  Future<void> saveAvailability() async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _therapistService.updateAvailability(uid, currentAvailability.value);
        Get.snackbar('Success', 'Availability updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save availability: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper to convert String "HH:mm" to TimeOfDay
  TimeOfDay stringToTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Helper to convert TimeOfDay to String "HH:mm"
  String timeToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
