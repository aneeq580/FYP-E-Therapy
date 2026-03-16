import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new report
  Future<void> createReport(ReportModel report) async {
    await _firestore.collection('reports').add(report.toMap());
  }

  // Get all reports authored by a specific therapist
  Stream<List<ReportModel>> getTherapistReports(String therapistId) {
    return _firestore
        .collection('reports')
        .where('therapistId', isEqualTo: therapistId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReportModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Get all reports for a specific patient
  Stream<List<ReportModel>> getPatientReports(String patientId) {
    return _firestore
        .collection('reports')
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReportModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
