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
    };
  }
}
