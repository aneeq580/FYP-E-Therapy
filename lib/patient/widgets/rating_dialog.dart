import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../controllers/appointment_controller.dart';
import '../../core/constants/colors.dart';

class RatingDialog extends StatefulWidget {
  final String therapistId;
  const RatingDialog({super.key, required this.therapistId});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate Your Session'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How was your experience with the therapist?'),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
      actions: [
        if (!_isSubmitting)
          TextButton(
            onPressed: () {
              Get.back(); // Skip
              Get.back(); // Close chat
            },
            child: const Text('Skip'),
          ),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  setState(() {
                    _isSubmitting = true;
                  });
                  await Get.find<AppointmentController>().rateTherapist(
                    widget.therapistId,
                    _rating,
                  );
                  Get.back(); // Close dialog
                  Get.back(); // Close chat
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}
