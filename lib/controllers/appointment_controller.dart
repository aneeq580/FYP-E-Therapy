import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

class AppointmentController extends GetxController {
  final AppointmentService _appointmentService = Get.find<AppointmentService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Streams for real-time updates
  RxList<AppointmentModel> patientAppointments = <AppointmentModel>[].obs;
  RxList<AppointmentModel> therapistPendingAppointments =
      <AppointmentModel>[].obs;
  RxList<AppointmentModel> therapistUpcomingAppointments =
      <AppointmentModel>[].obs;
  RxList<AppointmentModel> therapistCompletedAppointments =
      <AppointmentModel>[].obs;
  RxList<AppointmentModel> therapistCancelledAppointments =
      <AppointmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _bindStreams();
  }

  void _bindStreams() {
    final user = _auth.currentUser;
    if (user != null) {
      // Bind patient appointments
      patientAppointments.bindStream(
        _appointmentService.getPatientAppointments(user.uid),
      );

      // Bind therapist appointments
      therapistPendingAppointments.bindStream(
        _appointmentService.getPendingAppointments(user.uid),
      );
      therapistUpcomingAppointments.bindStream(
        _appointmentService.getUpcomingAppointments(user.uid),
      );
      therapistCompletedAppointments.bindStream(
        _appointmentService.getCompletedAppointments(user.uid),
      );
      therapistCancelledAppointments.bindStream(
        _appointmentService.getCancelledAppointments(user.uid),
      );
    }
  }

  Future<void> bookAppointment(AppointmentModel appointment) async {
    try {
      await _appointmentService.createAppointment(appointment);
      Get.snackbar('Success', 'Session booked successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to book session: $e');
    }
  }

  Future<void> acceptAppointment(String appointmentId) async {
    try {
      await _appointmentService.updateAppointmentStatus(
        appointmentId,
        'approved',
      );
      Get.snackbar('Success', 'Appointment accepted.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept appointment: $e');
    }
  }

  Future<void> completeAppointment(String appointmentId) async {
    try {
      await _appointmentService.updateAppointmentStatus(
        appointmentId,
        'completed',
      );
      Get.snackbar('Success', 'Session marked as completed.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete session: $e');
    }
  }

  Future<void> rejectAppointment(String appointmentId) async {
    try {
      await _appointmentService.updateAppointmentStatus(
        appointmentId,
        'cancelled',
      );
      Get.snackbar('Success', 'Appointment rejected.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject appointment: $e');
    }
  }

  Future<void> cancelAppointment(String appointmentId, {String? reason}) async {
    try {
      // Note: If you want to save 'reason', you can modify updateAppointmentStatus to accept a Map of fields
      // For now, just updating the status
      await _appointmentService.updateAppointmentStatus(
        appointmentId,
        'cancelled',
      );
      Get.snackbar('Success', 'Session cancelled successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel session: $e');
    }
  }
}
