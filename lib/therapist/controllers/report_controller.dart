import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/report_model.dart';
import '../../services/report_service.dart';

class ReportController extends GetxController {
  final ReportService _reportService = Get.put(ReportService());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<ReportModel> therapistReports = <ReportModel>[].obs;
  
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = _auth.currentUser;
    if (user != null) {
      therapistReports.bindStream(
        _reportService.getTherapistReports(user.uid),
      );
    }
  }

  Future<bool> createReport(ReportModel report) async {
    try {
      isLoading.value = true;
      await _reportService.createReport(report);
      
      // Explicitly refresh the reports list
      final user = _auth.currentUser;
      if (user != null) {
        final reports = await _reportService.getTherapistReports(user.uid).first;
        therapistReports.assignAll(reports);
      }
      
      Get.snackbar(
        'Success',
        'Report sent successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Small delay to ensure snackbar starts appearing before navigation
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send report: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
