import 'package:flutter/foundation.dart';

/// Core session entity used for both patient and therapist flows.
///
/// TODO: Replace dummy/local usage with Firestore model mapping.
class SessionModel {
  final String id;
  final String patientId;
  final String patientName;
  final String therapistId;
  final String therapistName;
  final DateTime sessionDateTime;
  final String sessionType;
  final String status; // "pending", "upcoming", "completed", "cancelled"
  final String? reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.therapistId,
    required this.therapistName,
    required this.sessionDateTime,
    required this.sessionType,
    required this.status,
    this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  SessionModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? therapistId,
    String? therapistName,
    DateTime? sessionDateTime,
    String? sessionType,
    String? status,
    String? reason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      therapistId: therapistId ?? this.therapistId,
      therapistName: therapistName ?? this.therapistName,
      sessionDateTime: sessionDateTime ?? this.sessionDateTime,
      sessionType: sessionType ?? this.sessionType,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'therapistId': therapistId,
      'therapistName': therapistName,
      'sessionDateTime': sessionDateTime.toIso8601String(),
      'sessionType': sessionType,
      'status': status,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] as String,
      patientId: map['patientId'] as String,
      patientName: map['patientName'] as String,
      therapistId: map['therapistId'] as String,
      therapistName: map['therapistName'] as String,
      sessionDateTime: DateTime.parse(map['sessionDateTime'] as String),
      sessionType: map['sessionType'] as String,
      status: map['status'] as String,
      reason: map['reason'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'SessionModel(id: $id, patientId: $patientId, therapistId: $therapistId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// String constants for all supported session statuses.
class SessionStatus {
  static const String pending = 'pending';
  static const String upcoming = 'upcoming';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  const SessionStatus._();
}
