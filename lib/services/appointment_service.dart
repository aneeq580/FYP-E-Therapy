import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/appointment_model.dart';

class AppointmentService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAppointment(AppointmentModel appointment) async {
    // ensure endTime is sent correctly; assume caller calculates it
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

  /// Sessions that are currently active for a patient.
  Stream<List<AppointmentModel>> getActivePatientSessions(String patientId) {
    final now = Timestamp.now();
    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .where('isActive', isEqualTo: true)
        // endTime filter moved to client side to avoid index
        .snapshots()
        .handleError((e) {
          debugPrint('getActivePatientSessions stream error: $e');
        })
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .where((appt) => appt.endTime.compareTo(now) > 0)
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
    // The “upcoming” tab should show appointments that haven’t begun yet.
    // Started sessions are surfaced via therapistActiveSessions instead,
    // so we omit the 'started' status here.  This ensures the card disappears
    // when the therapist hits Start.
    return _firestore
        .collection('appointments')
        .where('therapistId', isEqualTo: therapistId)
        .where('status', whereIn: ['approved', 'upcoming'])
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

  Stream<List<AppointmentModel>> getActiveTherapistSessions(
    String therapistId,
  ) {
    final now = Timestamp.now();
    return _firestore
        .collection('appointments')
        .where('therapistId', isEqualTo: therapistId)
        .where('isActive', isEqualTo: true)
        // endTime filter handled below to sidestep composite index
        .snapshots()
        .handleError((e) {
          debugPrint('getActiveTherapistSessions stream error: $e');
        })
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .where((appt) => appt.endTime.compareTo(now) > 0)
              .toList(),
        );
  }

  Future<void> updateAppointmentStatus(
    String appointmentId,
    String newStatus,
  ) async {
    final data = <String, dynamic>{'status': newStatus};
    if (newStatus == 'approved' || newStatus == 'upcoming') {
      data['acceptedAt'] = FieldValue.serverTimestamp();
    }
    if (newStatus == 'completed') {
      data['endedAt'] = FieldValue.serverTimestamp();
      data['isActive'] = false;
    }
    await _firestore.collection('appointments').doc(appointmentId).update(data);
  }

  /// Mark session as started and begin timer.
  Future<void> startSession(String appointmentId) async {
    // Use a transaction to atomically set startedAt, status, isActive and
    // compute chatRoomId if not already present.
    final ref = _firestore.collection('appointments').doc(appointmentId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;
      final data = snap.data()!;
      String? chatRoom = (data['chatRoomId'] as String?);
      if (chatRoom == null || chatRoom.isEmpty) {
        // assign unique room per session id
        chatRoom = appointmentId;
        tx.update(ref, {'chatRoomId': chatRoom});
      }
      tx.update(ref, {
        'startedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'status': 'started',
        'chatRoomId': chatRoom,
      });
    });
  }
}
