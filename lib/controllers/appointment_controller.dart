import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

class AppointmentController extends GetxController {
  final AppointmentService _appointmentService = Get.find<AppointmentService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Streams for real-time updates
  RxList<AppointmentModel> patientAppointments = <AppointmentModel>[].obs;

  /// Sessions currently ongoing (status == 'started') for patient
  RxList<AppointmentModel> patientOngoingSessions = <AppointmentModel>[].obs;

  RxList<AppointmentModel> therapistPendingAppointments =
      <AppointmentModel>[].obs;
  RxList<AppointmentModel> therapistUpcomingAppointments =
      <AppointmentModel>[].obs;
  RxList<AppointmentModel> therapistCompletedAppointments =
      <AppointmentModel>[].obs;
  RxList<AppointmentModel> therapistCancelledAppointments =
      <AppointmentModel>[].obs;

  /// sessions currently active for therapist
  RxList<AppointmentModel> therapistActiveSessions = <AppointmentModel>[].obs;

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
      patientOngoingSessions.bindStream(
        _appointmentService.getOngoingPatientSessions(user.uid),
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
      therapistActiveSessions.bindStream(
        _appointmentService.getActiveTherapistSessions(user.uid),
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

  Future<void> startSession(String appointmentId) async {
    try {
      await _appointmentService.startSession(appointmentId);
      Get.snackbar('Session started', 'Session has started.');
    } catch (e) {
      Get.snackbar('Error', 'Unable to start session: $e');
    }
  }

  Future<void> cancelAppointment(String appointmentId, {String? reason}) async {
    try {
      await _appointmentService.updateAppointmentStatus(
        appointmentId,
        'cancelled',
      );
      Get.snackbar('Success', 'Session cancelled successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel session: $e');
    }
  }

  Future<void> rateTherapist(String therapistId, double rating) async {
    try {
      final db = FirebaseFirestore.instance;
      final docRef = db.collection('users').doc(therapistId);
      
      await db.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final data = snapshot.data();
        if (data == null) return;

        final double currentRating = (data['rating'] as num?)?.toDouble() ?? 5.0;
        final int ratingCount = (data['ratingCount'] as num?)?.toInt() ?? 0;
        
        final double newRating = ((currentRating * ratingCount) + rating) / (ratingCount + 1);
        
        transaction.update(docRef, {
          'rating': newRating,
          'ratingCount': ratingCount + 1,
        });
      });

      // Maintain a log of reviews
      await docRef.collection('reviews').add({
        'rating': rating,
        'patientId': _auth.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      Get.snackbar('Success', 'Thank you for your feedback!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit rating: $e');
    }
  }
}
