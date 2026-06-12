import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../models/resource_model.dart';

class MeditationCard extends StatefulWidget {
  final ResourceModel resource;

  const MeditationCard({super.key, required this.resource});

  @override
  State<MeditationCard> createState() => _MeditationCardState();
}

class _MeditationCardState extends State<MeditationCard> {
  bool _isGuideOpen = false;

  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;
    final backgroundColor = resource.color ?? Colors.white;
    final borderColor = resource.topBorderColor ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
            Container(height: 4, width: double.infinity, color: borderColor),
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: FaIcon(
                          resource.icon ?? FontAwesomeIcons.spa,
                          size: 24,
                          color: borderColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resource.title,
                              style: AppTextStyles.bodyText.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              resource.description,
                              style: AppTextStyles.bodyTextSecondary.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                        '${resource.duration?.inMinutes ?? 10} min',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (resource.tag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Text(
                            resource.tag!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Start Meditation / Close Guide Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isGuideOpen = !_isGuideOpen;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          _isGuideOpen
                              ? FontAwesomeIcons.xmark
                              : FontAwesomeIcons.play,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isGuideOpen ? 'Close Guide' : 'Start Meditation',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (_isGuideOpen) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor.withOpacity(0.1)),
                      ),
                      child: Text(
                        resource.content,
                        style: AppTextStyles.bodyText.copyWith(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
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
