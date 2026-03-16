import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/therapist_app_bar.dart';
import '../../routes/app_routes.dart';
import '../controllers/report_controller.dart';
import 'package:intl/intl.dart';

class TherapistReportsScreen extends StatefulWidget {
  const TherapistReportsScreen({super.key});

  @override
  State<TherapistReportsScreen> createState() => _TherapistReportsScreenState();
}

class _TherapistReportsScreenState extends State<TherapistReportsScreen> {
  final ReportController _reportCtrl = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: const TherapistAppBar(title: "Session Reports"),
      body: Obx(() {
        if (_reportCtrl.therapistReports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: AppColors.therapistPrimary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  "No reports yet",
                  style: AppTextStyles.headerSubtitle.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create reports to summarize sessions for your patients.",
                  style: AppTextStyles.bodyTextSecondary,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _reportCtrl.therapistReports.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final report = _reportCtrl.therapistReports[index];
            final dateStr = DateFormat(
              'MMM dd, yyyy - hh:mm a',
            ).format(report.createdAt.toDate());

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
                      Text(
                        report.patientName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.createReport),
        backgroundColor: AppColors.therapistPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Create Report",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
