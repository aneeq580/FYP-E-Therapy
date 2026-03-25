import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/therapist_app_bar.dart';
import '../../models/appointment_model.dart';
import '../../models/report_model.dart';
import '../controllers/report_controller.dart';
import '../../controllers/appointment_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final ReportController _reportCtrl = Get.find<ReportController>();
  final AppointmentController _apptCtrl = Get.find<AppointmentController>();
  
  AppointmentModel? _selectedAppointment;
  final TextEditingController _summaryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    // Unfocus the keyboard to ensure the snackbar is visible
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate() || _selectedAppointment == null) {
      if (_selectedAppointment == null) {
        Get.snackbar(
          'Error',
          'Please select a session to write a report for.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    final therapistId = FirebaseAuth.instance.currentUser!.uid;

    final newReport = ReportModel(
      id: '', // Will be assigned by Firestore
      appointmentId: _selectedAppointment!.id,
      patientId: _selectedAppointment!.patientId,
      therapistId: therapistId,
      patientName: _selectedAppointment!.patientName,
      summary: _summaryController.text.trim(),
      createdAt: Timestamp.now(),
    );

    final success = await _reportCtrl.createReport(newReport);
    if (success) {
      // Clear current screen but give enough time to show snackbar (already handled in controller delay)
      Get.back(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter completed appointments only
    final completedAppointments = _apptCtrl.therapistCompletedAppointments
        .where((appt) => appt.status == 'completed')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: const TherapistAppBar(title: "New Report"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Session",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              
              // Dropdown to select appointment
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AppointmentModel>(
                    isExpanded: true,
                    hint: const Text("Select a completed session"),
                    value: _selectedAppointment,
                    items: completedAppointments.map((appt) {
                      final dateStr = DateFormat('MMM dd, yyyy - ha').format(appt.date.toDate());
                      return DropdownMenuItem<AppointmentModel>(
                        value: appt,
                        child: Text("${appt.patientName} • $dateStr"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAppointment = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Session Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              
              // Summary Text Field
              TextFormField(
                controller: _summaryController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Write your session notes and summary for the patient...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Summary cannot be empty";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),
              
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.therapistPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _reportCtrl.isLoading.value ? () {} : _submitReport,
                  child: _reportCtrl.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save & Send Report",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
