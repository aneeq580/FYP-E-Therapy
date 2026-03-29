import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String appointmentId;
  final String patientId;
  final String therapistId;
  final String patientName;
  final String title;
  final String summary;
  final Timestamp createdAt;

  ReportModel({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.therapistId,
    required this.patientName,
    required this.title,
    required this.summary,
    required this.createdAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ReportModel(
      id: documentId,
      appointmentId: data['appointmentId'] ?? '',
      patientId: data['patientId'] ?? '',
      therapistId: data['therapistId'] ?? '',
      patientName: data['patientName'] ?? 'Unknown Patient',
      title: data['title'] ?? 'Session Report',
      summary: data['summary'] ?? '',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'therapistId': therapistId,
      'patientName': patientName,
      'title': title,
      'summary': summary,
      'createdAt': createdAt,
    };
  }
}
