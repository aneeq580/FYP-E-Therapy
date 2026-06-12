import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../models/resource_model.dart';

class BreathingExerciseCard extends StatefulWidget {
  final ResourceModel resource;

  const BreathingExerciseCard({super.key, required this.resource});

  @override
  State<BreathingExerciseCard> createState() => _BreathingExerciseCardState();
}

class _BreathingExerciseCardState extends State<BreathingExerciseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Top colored border
            Container(
              height: 4,
              width: double.infinity,
              color: resource.topBorderColor ?? AppColors.primary,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          resource.title,
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (resource.difficulty != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            resource.difficulty!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    resource.description,
                    style: AppTextStyles.bodyTextSecondary,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.clock,
                        size: 14,
                        color: AppColors.iconResources,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${resource.duration?.inMinutes ?? 5} min',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (resource.benefits != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1), // Light teal background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        resource.benefits!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF00796B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Show/Hide Steps Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isExpanded ? 'Hide Steps' : 'Show Steps',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          FaIcon(
                            _isExpanded
                                ? FontAwesomeIcons.chevronUp
                                : FontAwesomeIcons.chevronRight,
                            color: Colors.grey[700],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExpanded && resource.steps != null) ...[
                    const SizedBox(height: 16),
                    ...List.generate(resource.steps!.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE0F2F1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00796B),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                resource.steps![index],
                                style: AppTextStyles.bodyText.copyWith(
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
