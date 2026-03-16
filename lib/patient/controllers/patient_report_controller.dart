import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/report_model.dart';
import '../../services/report_service.dart';

class PatientReportController extends GetxController {
  final ReportService _reportService = Get.find<ReportService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<ReportModel> patientReports = <ReportModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    final user = _auth.currentUser;
    if (user != null) {
      patientReports.bindStream(
        _reportService.getPatientReports(user.uid),
      );
    }
  }
}
