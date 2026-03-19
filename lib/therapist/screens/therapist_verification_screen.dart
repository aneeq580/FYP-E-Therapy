import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/therapist_verification_controller.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:fyp_therapy/therapist/widgets/degree_upload_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/widgets/therapist_app_bar.dart';

class TherapistVerificationScreen extends StatelessWidget {
  const TherapistVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TherapistVerificationController());

    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: const TherapistAppBar(
        title: "Verification",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Status Section
            Obx(() {
              return _buildStatusIndicator(controller.verificationStatus.value);
            }),
            
            const SizedBox(height: 32),
            
            // Upload Section
            Obx(() {
              final status = controller.verificationStatus.value;
              if (status == 'approved') {
                return _buildVerifiedInfo();
              } else if (status == 'pending') {
                return _buildPendingInfo();
              } else {
                return const DegreeUploadCard();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case 'approved':
        color = Colors.green;
        text = "Verified Account";
        icon = FontAwesomeIcons.circleCheck;
        break;
      case 'pending':
        color = Colors.orange;
        text = "Verification Pending";
        icon = FontAwesomeIcons.clock;
        break;
      case 'rejected':
        color = Colors.red;
        text = "Verification Rejected";
        icon = FontAwesomeIcons.circleExclamation;
        break;
      default:
        color = Colors.grey;
        text = "Account Not Verified";
        icon = FontAwesomeIcons.shieldHalved;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          FaIcon(icon, color: color, size: 50),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (status == 'rejected') ...[
            const SizedBox(height: 12),
            const Text(
              "Please upload your degree certificate again making sure all details are clearly visible.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerifiedInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: const Column(
        children: [
          Text(
            "Congratulations!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            "Your professional degree has been verified. You now have full access to all therapist features including live sessions and report generation.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.therapistTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Text(
            "Under Review",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            "Your document is currently being reviewed by our team. This process usually takes 24-48 hours. We will notify you once your account is verified.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.therapistTextSecondary),
          ),
        ],
      ),
    );
  }
}
