import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../controllers/patient_report_controller.dart';
import 'package:intl/intl.dart';

class PatientReportsScreen extends StatelessWidget {
  const PatientReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller when screen is accessed
    final PatientReportController reportCtrl = Get.put(PatientReportController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: "Session Summaries", showDefaultActions: false),
      body: Obx(() {
        if (reportCtrl.patientReports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: 64,
                  color: AppColors.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  "No summaries yet",
                  style: AppTextStyles.headerSubtitle.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  "Reports written by your therapist will appear here.",
                  style: AppTextStyles.bodyTextSecondary,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.spacingMedium),
          itemCount: reportCtrl.patientReports.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final report = reportCtrl.patientReports[index];
            final dateStr = DateFormat('MMM dd, yyyy').format(report.createdAt.toDate());

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assignment_turned_in, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Therapy Session",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    report.summary,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
