import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

/// Manages a single appointment/session document and countdown logic.
///
/// The controller listens to the Firestore document at `appointments/{id}`
/// and exposes reactive values used by both patient and therapist screens.
///
/// It also provides methods that the therapist can call to start the session and
/// automatically mark it completed when the timer expires.  Countdown updates
/// fire every second and are available via the `remaining` observable.
class SessionController extends GetxController {
  SessionController({required this.sessionId, required this.isTherapist});

  final String sessionId;
  final bool isTherapist;

  final _firestore = FirebaseFirestore.instance;
  late final DocumentReference<Map<String, dynamic>> _docRef;

  // raw fields from firestore
  final status = ''.obs;
  final startedAt = Rxn<DateTime>();
  final durationMinutes = RxnInt();
  final chatRoomId = ''.obs;
  final patientName = ''.obs;
  final therapistName = ''.obs;
  final patientId = ''.obs;
  final therapistId = ''.obs;

  // derived values
  final remaining = Duration.zero.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _docRef = _firestore.collection('appointments').doc(sessionId);
    _docRef.snapshots().listen(_handleSnapshot);
  }

  void _handleSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    if (!snap.exists) return;
    final data = snap.data()!;
    status.value = (data['status'] as String? ?? '').toLowerCase();
    if (data['startedAt'] is Timestamp) {
      startedAt.value = (data['startedAt'] as Timestamp).toDate();
    }
    durationMinutes.value = (data['duration'] as int?) ?? 0;
    patientName.value = (data['patientName'] as String?) ?? '';
    therapistName.value = (data['therapistName'] as String?) ?? '';
    patientId.value = (data['patientId'] as String?) ?? '';
    therapistId.value = (data['therapistId'] as String?) ?? '';

    // ensure chatRoomId exists so both sides know where to listen
    final existing = data['chatRoomId'] as String?;
    if (existing != null && existing.isNotEmpty) {
      chatRoomId.value = existing;
    } else {
      // use the session (document) id itself for uniqueness per session
      chatRoomId.value = sessionId;
      // write back first time
      _docRef.update({'chatRoomId': chatRoomId.value});
    }

    // either status may be 'started' or legacy 'active'
    if (status.value == 'started' || status.value == 'active') {
      _startTimerIfNeeded();
    } else {
      _stopTimer();
      if (status.value == 'completed') {
        remaining.value = Duration.zero;
      }
    }
  }

  String get partnerName =>
      isTherapist ? patientName.value : therapistName.value;
  String get partnerId => isTherapist ? patientId.value : therapistId.value;

  bool get chatEnabled {
    final s = status.value.toLowerCase();
    return s == 'started' || s == 'active';
  }

  void _startTimerIfNeeded() {
    if (_timer != null) return;
    if (startedAt.value == null || durationMinutes.value == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final end = startedAt.value!.add(Duration(minutes: durationMinutes.value!));
      final diff = end.difference(DateTime.now());
      if (diff <= Duration.zero) {
        remaining.value = Duration.zero;
        _stopTimer();
        _completeSession();
      } else {
        remaining.value = diff;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _completeSession() async {
    await _docRef.update({
      'status': 'completed',
      'endedAt': FieldValue.serverTimestamp(),
      'isActive': false,
    });
  }

  /// Extend session duration by 5 minutes.
  Future<void> extendSession() async {
    if (durationMinutes.value != null) {
      await _docRef.update({
        'duration': FieldValue.increment(5),
      });
    }
  }

  /// Called by therapist when "Start Session" button is pressed.
  Future<void> startSession() async {
    if (!isTherapist) return;
    await _docRef.update({
      'status': 'started',
      'startedAt': FieldValue.serverTimestamp(),
      'isActive': true,
      'chatRoomId': chatRoomId.value,
    });
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}
