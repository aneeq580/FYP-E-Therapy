import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:fyp_therapy/core/widgets/therapist_app_bar.dart';
import '../controllers/availability_controller.dart';
import '../../models/availability_model.dart';

class AvailabilityScreen extends GetView<AvailabilityController> {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AvailabilityController>()) {
      Get.put(AvailabilityController());
    }

    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Scaffold(
      backgroundColor: AppColors.therapistBackground,
      appBar: const TherapistAppBar(title: "Manage Availability"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final availability = controller.currentAvailability.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Set your weekdays availability",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Timezone: Asia/Karachi (PKT)",
                style: TextStyle(color: Colors.blueAccent, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Days List
              ...days.map((day) => _buildDayCard(context, day, availability)),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveAvailability,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.therapistPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Save Availability",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDayCard(
    BuildContext context,
    String day,
    AvailabilityModel availability,
  ) {
    final isEnabled = availability.weeklyAvailability.containsKey(day);
    final slots = availability.weeklyAvailability[day] ?? [];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
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
        border: Border.all(
          color: isEnabled
              ? AppColors.therapistPrimary.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isEnabled
                        ? AppColors.therapistPrimary
                        : Colors.black87,
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: (_) => controller.toggleDay(day),
                  activeColor: AppColors.therapistPrimary,
                ),
              ],
            ),
          ),

          if (isEnabled) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...slots.asMap().entries.map((entry) {
                    final index = entry.key;
                    final slot = entry.value;
                    return _buildTimeSlotRow(context, day, index, slot);
                  }),

                  const SizedBox(height: 12),

                  // Add More Button for this specific day
                  TextButton.icon(
                    onPressed: () => controller.addSlot(day),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: const Text("Add another slot"),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.therapistPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "Currently Unavailable",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotRow(
    BuildContext context,
    String day,
    int index,
    TimeSlot slot,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: _TimeDisplay(
              label: "Start",
              time: slot.start,
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: controller.stringToTime(slot.start),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(alwaysUse24HourFormat: false),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  controller.updateSlotTime(
                    day,
                    index,
                    start: controller.timeToString(picked),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.arrow_forward,
              color: AppColors.iconResources,
              size: 16,
            ),
          ),
          Expanded(
            child: _TimeDisplay(
              label: "End",
              time: slot.end,
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: controller.stringToTime(slot.end),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(alwaysUse24HourFormat: false),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  controller.updateSlotTime(
                    day,
                    index,
                    end: controller.timeToString(picked),
                  );
                }
              },
            ),
          ),
          if (index > 0)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.iconEmergency,
                size: 22,
              ),
              onPressed: () => controller.removeSlot(day, index),
            ),
        ],
      ),
    );
  }
}

class _TimeDisplay extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const _TimeDisplay({
    required this.label,
    required this.time,
    required this.onTap,
  });

  String get _formattedTime {
    final parts = time.split(':');
    final h = int.parse(parts[0]);
    final m = parts[1];
    final hour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final period = h >= 12 ? 'PM' : 'AM';
    return '$hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formattedTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.therapistPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
