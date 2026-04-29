import 'package:get/get.dart';
import 'package:fyp_therapy/services/auth_service.dart';
import '../../models/appointment_model.dart';
import '../../services/appointment_service.dart';

class TherapistPatientDetailController extends GetxController {
  TherapistPatientDetailController() : _authService = Get.find<AuthService>();

  final AuthService _authService;
  final AppointmentService _appointmentService = Get.find<AppointmentService>();
  final isLoading = false.obs;
  final profile = Rxn<Map<String, dynamic>>();
  final patientAppointments = <AppointmentModel>[].obs;

  Future<void> loadProfile(String uid) async {
    isLoading.value = true;
    try {
      profile.value = await _authService.fetchUserProfile(uid);
      // Load patient appointments
      await loadPatientAppointments(uid);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPatientAppointments(String patientId) async {
    try {
      final appointments = await _appointmentService
          .getPatientAppointments(patientId)
          .first;
      patientAppointments.assignAll(appointments);
      // Sort by date, most recent first
      patientAppointments.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print('Error loading patient appointments: $e');
    }
  }
}
