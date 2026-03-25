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
        .snapshots()
        .map((snapshot) {
      final reports = snapshot.docs
          .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort in-memory to avoid requiring composite indexing
      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reports;
    });
  }

  // Get all reports for a specific patient
  Stream<List<ReportModel>> getPatientReports(String patientId) {
    return _firestore
        .collection('reports')
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map((snapshot) {
      final reports = snapshot.docs
          .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort in-memory to avoid requiring composite indexing
      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reports;
    });
  }
}
