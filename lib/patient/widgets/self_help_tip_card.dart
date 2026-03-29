import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../models/resource_model.dart';

class SelfHelpTipCard extends StatefulWidget {
  final ResourceModel resource;

  const SelfHelpTipCard({super.key, required this.resource});

  @override
  State<SelfHelpTipCard> createState() => _SelfHelpTipCardState();
}

class _SelfHelpTipCardState extends State<SelfHelpTipCard> {
  bool _isExpanded = false;

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
            Container(
              height: 4,
              width: double.infinity,
              color: borderColor,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        resource.icon ?? FontAwesomeIcons.lightbulb,
                        size: 24,
                        color: borderColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        resource.title,
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    resource.description,
                    style: AppTextStyles.bodyTextSecondary.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Show/Hide Tips Button
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
                        color: Colors.white.withOpacity(0.8),
                        border: Border.all(color: borderColor.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isExpanded ? 'Hide Tips' : 'Show Tips',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: borderColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FaIcon(
                            _isExpanded ? FontAwesomeIcons.chevronUp : FontAwesomeIcons.chevronRight,
                            color: borderColor.withOpacity(0.8),
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
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: FaIcon(
                                FontAwesomeIcons.solidCircle,
                                size: 6,
                                color: Color(0xFF00897B), // Teal bullet
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                resource.steps![index],
                                style: AppTextStyles.bodyText.copyWith(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: Colors.black.withOpacity(0.8),
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
