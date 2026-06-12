import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../models/resource_model.dart';

class ResourceDetailView extends StatelessWidget {
  final ResourceModel resource;

  const ResourceDetailView({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PatientAppBar(title: resource.title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resource.icon != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.spacingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.iconBgResources,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    resource.icon,
                    color: AppColors.iconResources,
                    size: 64,
                  ),
                ),
              ),
            const SizedBox(height: AppSizes.spacingLarge),
            if (resource.tag != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      resource.tagColor ??
                      resource.color?.withOpacity(0.3) ??
                      AppColors.iconBgResources,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  resource.tag!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.alphaBlend(
                      Colors.black.withOpacity(0.6),
                      resource.tagColor ?? resource.color ?? AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              resource.title,
              style: AppTextStyles.headerTitle.copyWith(
                color: AppColors.textPrimary,
                fontSize: AppTextStyles.fontSizeXXLarge,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (resource.readTime != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: AppColors.iconResources,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    resource.readTime!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                ],
                if (resource.rating != null) ...[
                  const Icon(Icons.star, size: 18, color: Color(0xFFFFD700)),
                  const SizedBox(width: 4),
                  Text(
                    resource.rating!.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (resource.duration != null) ...[
                  Icon(
                    Icons.timer_outlined,
                    size: 18,
                    color: AppColors.iconResources,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${resource.duration!.inMinutes} min exercise',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            const Divider(),
            const SizedBox(height: AppSizes.spacingMedium),
            Text(
              resource.description,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            Text(
              resource.content,
              style: AppTextStyles.bodyText.copyWith(
                height: 1.6,
                fontSize: AppTextStyles.fontSizeLarge,
              ),
            ),
            if (resource.benefits != null) ...[
              const SizedBox(height: AppSizes.spacingLarge),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.spacingMedium),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Benefits',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00796B),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resource.benefits!,
                      style: const TextStyle(
                        color: Color(0xFF00796B),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (resource.steps != null) ...[
              const SizedBox(height: AppSizes.spacingLarge),
              Text(
                'Steps',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              ...List.generate(resource.steps!.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0F2F1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
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
                          style: AppTextStyles.bodyText.copyWith(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: AppSizes.spacingLarge),
            if (resource.category == ResourceCategory.breathing ||
                resource.category == ResourceCategory.meditation)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logic for starting a timer or exercise could go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exercise starting soon!')),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Exercise'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
