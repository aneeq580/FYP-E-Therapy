import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String therapistId;
  final String therapistName;
  final Timestamp date;
  final int duration; // minutes
  final Timestamp endTime;
  final String status;

  final Timestamp? createdAt;
  final Timestamp? acceptedAt;
  final Timestamp? startedAt;
  final Timestamp? endedAt;
  final bool isActive;

  /// optional value used for chat room documents (patient_therapist sorted)
  final String? chatRoomId;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.therapistId,
    required this.therapistName,
    required this.date,
    required this.duration,
    required this.endTime,
    required this.status,
    this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.endedAt,
    this.isActive = false,
    this.chatRoomId,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> data, String curId) {
    return AppointmentModel(
      id: curId,
      patientId: data['patientId'] ?? '',
      patientName: data['patientName'] ?? '',
      therapistId: data['therapistId'] ?? '',
      therapistName: data['therapistName'] ?? '',
      date: data['date'] as Timestamp,
      duration: data['duration'] as int? ?? 0,
      endTime: data['endTime'] as Timestamp? ?? (data['date'] as Timestamp),
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] as Timestamp?,
      acceptedAt: data['acceptedAt'] as Timestamp?,
      startedAt: data['startedAt'] as Timestamp?,
      endedAt: data['endedAt'] as Timestamp?,
      isActive: data['isActive'] as bool? ?? false,
      chatRoomId: data['chatRoomId'] as String?,
    );
  }

  /// utility for making modified copies without rebuilding all fields
  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? therapistId,
    String? therapistName,
    Timestamp? date,
    int? duration,
    Timestamp? endTime,
    String? status,
    Timestamp? createdAt,
    Timestamp? acceptedAt,
    Timestamp? startedAt,
    Timestamp? endedAt,
    bool? isActive,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      therapistId: therapistId ?? this.therapistId,
      therapistName: therapistName ?? this.therapistName,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'patientName': patientName,
      'therapistId': therapistId,
      'therapistName': therapistName,
      'date': date,
      'duration': duration,
      'endTime': endTime,
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'acceptedAt': acceptedAt,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'isActive': isActive,
      'chatRoomId': chatRoomId,
    };
  }
}
