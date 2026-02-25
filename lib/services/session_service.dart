import 'package:get/get.dart';

import '../models/session_model.dart';

/// Fake current user identifiers used for local dummy state only.
///
/// TODO: Replace with authenticated user IDs from Firebase Auth.
const String currentPatientId = 'patient_123';
const String currentTherapistId = 'therapist_456';

/// GetX service responsible for managing all therapy sessions in-memory.
///
/// TODO: Replace dummy list operations with Firestore reads/writes.
class SessionService extends GetxService {
  final RxList<SessionModel> allSessions = <SessionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummySessions();
  }

  void _loadDummySessions() {
    final now = DateTime.now();

    allSessions.assignAll([
      // Pending requests for the current therapist
      SessionModel(
        id: 's1',
        patientId: currentPatientId,
        patientName: 'Alex Johnson',
        therapistId: currentTherapistId,
        therapistName: 'Dr. Sarah Johnson',
        sessionDateTime: now.add(const Duration(days: 1, hours: 2)),
        sessionType: 'Online video',
        status: SessionStatus.pending,
        reason: 'Feeling overwhelmed with work stress.',
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      SessionModel(
        id: 's2',
        patientId: currentPatientId,
        patientName: 'Alex Johnson',
        therapistId: currentTherapistId,
        therapistName: 'Dr. Michael Chen',
        sessionDateTime: now.add(const Duration(days: 2, hours: 3)),
        sessionType: 'Online video',
        status: SessionStatus.pending,
        reason: 'Follow-up session.',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),

      // Upcoming sessions
      SessionModel(
        id: 's3',
        patientId: currentPatientId,
        patientName: 'Alex Johnson',
        therapistId: currentTherapistId,
        therapistName: 'Dr. Emily Rodriguez',
        sessionDateTime: now.add(const Duration(days: 3)),
        sessionType: 'In-person',
        status: SessionStatus.upcoming,
        reason: 'Relationship counselling.',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // Completed session
      SessionModel(
        id: 's4',
        patientId: currentPatientId,
        patientName: 'Alex Johnson',
        therapistId: currentTherapistId,
        therapistName: 'Dr. Sarah Johnson',
        sessionDateTime: now.subtract(const Duration(days: 4)),
        sessionType: 'Online video',
        status: SessionStatus.completed,
        reason: 'Initial assessment.',
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),

      // Cancelled session
      SessionModel(
        id: 's5',
        patientId: currentPatientId,
        patientName: 'Alex Johnson',
        therapistId: currentTherapistId,
        therapistName: 'Dr. James Wilson',
        sessionDateTime: now.subtract(const Duration(days: 1)),
        sessionType: 'Online video',
        status: SessionStatus.cancelled,
        reason: 'Patient requested to reschedule.',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

  /// Book a new session as *pending* for the current patient.
  ///
  /// The [newSession] object can provide other details; status will always
  /// be normalized to `"pending"` for a fresh booking.
  ///
  /// TODO: Replace with Firestore.add() to persist the session.
  void bookSession(SessionModel newSession) {
    final pendingSession = newSession.copyWith(
      status: SessionStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    allSessions.add(pendingSession);

    Get.snackbar(
      'Request sent!',
      'Your session request has been sent to the therapist.',
    );
  }

  /// Get sessions for the *current patient* filtered by status.
  ///
  /// Returns a new observable list each time so that callers can safely
  /// transform or sort without mutating the source.
  RxList<SessionModel> getMySessions(String status) {
    final filtered = allSessions
        .where((s) => s.patientId == currentPatientId && s.status == status)
        .toList();
    return filtered.obs;
  }

  /// Get all *pending* requests for the current therapist.
  RxList<SessionModel> getPendingRequests() {
    final filtered = allSessions
        .where(
          (s) =>
              s.therapistId == currentTherapistId &&
              s.status == SessionStatus.pending,
        )
        .toList();
    return filtered.obs;
  }

  void acceptSession(String id) {
    _updateSessionStatus(
      id: id,
      newStatus: SessionStatus.upcoming,
      title: 'Session accepted',
      message: 'The session has been marked as upcoming.',
    );
  }

  void rejectSession(String id) {
    _updateSessionStatus(
      id: id,
      newStatus: SessionStatus.cancelled,
      title: 'Session cancelled',
      message: 'The session request has been cancelled.',
    );
  }

  void markCompleted(String id) {
    _updateSessionStatus(
      id: id,
      newStatus: SessionStatus.completed,
      title: 'Session completed',
      message: 'The session has been marked as completed.',
    );
  }

  void _updateSessionStatus({
    required String id,
    required String newStatus,
    required String title,
    required String message,
  }) {
    final index = allSessions.indexWhere((s) => s.id == id);
    if (index == -1) return;

    final updated = allSessions[index].copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    allSessions[index] = updated;

    Get.snackbar(title, message);
  }
}
