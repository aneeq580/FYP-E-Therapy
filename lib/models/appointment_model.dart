import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String therapistId;
  final String therapistName;
  final Timestamp date;
  final String status;
  final Timestamp? createdAt;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.therapistId,
    required this.therapistName,
    required this.date,
    required this.status,
    this.createdAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> data, String curId) {
    return AppointmentModel(
      id: curId,
      patientId: data['patientId'] ?? '',
      patientName: data['patientName'] ?? '',
      therapistId: data['therapistId'] ?? '',
      therapistName: data['therapistName'] ?? '',
      date: data['date'] as Timestamp,
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'patientName': patientName,
      'therapistId': therapistId,
      'therapistName': therapistName,
      'date': date,
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
