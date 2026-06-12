import 'package:flutter/material.dart';
import 'package:fyp_therapy/controllers/therapist_verification_controller.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DegreeUploadCard extends StatelessWidget {
  const DegreeUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TherapistVerificationController());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Degree Certificate",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.therapistTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Upload a clear copy of your professional degree certificate (PDF, JPG, or PNG. Max 5MB).",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.therapistTextSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // File Selection Area
            Obx(() {
              final pickedFile = controller.pickedFile.value;
              final fileName = controller.pickedFileName.value;

              return Column(
                children: [
                  GestureDetector(
                    onTap: controller.isUploading.value
                        ? null
                        : controller.pickDegreeFile,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.therapistPrimary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.therapistPrimary.withOpacity(0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: pickedFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.cloudArrowUp,
                                  color: AppColors.therapistPrimary.withOpacity(
                                    0.5,
                                  ),
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Tap to select file",
                                  style: TextStyle(
                                    color: AppColors.therapistPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        _getFileIcon(fileName),
                                        color: AppColors.therapistPrimary,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          fileName,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: AppColors.iconEmergency,
                                    ),
                                    onPressed: () =>
                                        controller.pickedFile.value = null,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  if (pickedFile != null) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isUploading.value
                            ? null
                            : controller.uploadDegree,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.therapistPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isUploading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Upload for Verification",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return FontAwesomeIcons.filePdf;
    } else if (fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg') ||
        fileName.toLowerCase().endsWith('.png')) {
      return FontAwesomeIcons.fileImage;
    }
    return FontAwesomeIcons.file;
  }
}
