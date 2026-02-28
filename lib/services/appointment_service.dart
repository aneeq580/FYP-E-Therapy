import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/appointment_model.dart';

class AppointmentService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAppointment(AppointmentModel appointment) async {
    await _firestore.collection('appointments').add(appointment.toMap());
  }

  Stream<List<AppointmentModel>> getPatientAppointments(String patientId) {
    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<AppointmentModel>> getPendingAppointments(String therapistId) {
    return _firestore
        .collection('appointments')
        .where('therapistId', isEqualTo: therapistId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<AppointmentModel>> getUpcomingAppointments(String therapistId) {
    return _firestore
        .collection('appointments')
        .where('therapistId', isEqualTo: therapistId)
        .where('status', whereIn: ['approved', 'upcoming']) // fallback for both
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<AppointmentModel>> getCompletedAppointments(String therapistId) {
    return _firestore
        .collection('appointments')
        .where('therapistId', isEqualTo: therapistId)
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<AppointmentModel>> getCancelledAppointments(String therapistId) {
    return _firestore
        .collection('appointments')
        .where('therapistId', isEqualTo: therapistId)
        .where('status', isEqualTo: 'cancelled')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> updateAppointmentStatus(
    String appointmentId,
    String newStatus,
  ) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': newStatus,
    });
  }
}
