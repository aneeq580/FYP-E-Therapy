import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../models/resource_model.dart';
import '../../core/constants/resource_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'resource_detail_view.dart';
import '../widgets/expandable_resource_card.dart';
import '../widgets/meditation_card.dart';
import '../widgets/self_help_tip_card.dart';

class ResourceListScreen extends StatefulWidget {
  final String title;
  final ResourceCategory category;

  const ResourceListScreen({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  late ResourceCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    final resources = ResourceData.getByCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PatientAppBar(title: _getCategoryTitle(_selectedCategory)),
      body: Column(
        children: [
          _buildCategorySelector(),
          Expanded(
            child: resources.isEmpty
                ? const Center(
                    child: Text('No resources found for this category.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.spacingMedium),
                    itemCount: resources.length,
                    itemBuilder: (context, index) {
                      final resource = resources[index];

                      // For breathing exercises, use the new expandable card
                      if (resource.category == ResourceCategory.breathing) {
                        return BreathingExerciseCard(resource: resource);
                      }

                      // For meditations, use the new meditation card
                      if (resource.category == ResourceCategory.meditation) {
                        return MeditationCard(resource: resource);
                      }

                      // For self-help tips, use the new tip card
                      if (resource.category == ResourceCategory.selfHelp) {
                        return SelfHelpTipCard(resource: resource);
                      }

                      // For articles, use the new card design from the screenshot
                      if (resource.category == ResourceCategory.articles &&
                          resource.color != null) {
                        final cardColor = resource.color!;
                        final tagColor =
                            resource.tagColor ??
                            Color.alphaBlend(
                              Colors.black.withOpacity(0.05),
                              cardColor,
                            );
                        final textColor = Color.alphaBlend(
                          Colors.black.withOpacity(0.6),
                          tagColor,
                        );

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResourceDetailView(resource: resource),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: AppSizes.spacingMedium,
                            ),
                            padding: const EdgeInsets.all(
                              AppSizes.spacingMedium,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (resource.tag != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tagColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      resource.tag!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                Text(
                                  resource.title,
                                  style: AppTextStyles.bodyText.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  resource.description,
                                  style: AppTextStyles.bodyTextSecondary
                                      .copyWith(fontSize: 14, height: 1.4),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    if (resource.readTime != null) ...[
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        resource.readTime!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                    const Spacer(),
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFD700),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      resource.rating?.toString() ?? '4.8',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Default design for other categories
                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: AppSizes.spacingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(
                            AppSizes.spacingMedium,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(
                              AppSizes.spacingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.iconBgResources,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              resource.icon ?? Icons.book,
                              color: AppColors.iconResources,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            resource.title,
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: AppTextStyles.fontSizeLarge,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              resource.description,
                              style: AppTextStyles.bodyTextSecondary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResourceDetailView(resource: resource),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      {
        'type': ResourceCategory.articles,
        'label': 'Articles',
        'icon': FontAwesomeIcons.bookOpen,
      },
      {
        'type': ResourceCategory.breathing,
        'label': 'Breathing',
        'icon': FontAwesomeIcons.wind,
      },
      {
        'type': ResourceCategory.meditation,
        'label': 'Meditation',
        'icon': FontAwesomeIcons.om,
      },
      {
        'type': ResourceCategory.selfHelp,
        'label': 'Self Help Tips',
        'icon': FontAwesomeIcons.lightbulb,
      },
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['type'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat['type'] as ResourceCategory;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00897B)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 14,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCategoryTitle(ResourceCategory category) {
    switch (category) {
      case ResourceCategory.articles:
        return 'Articles';
      case ResourceCategory.breathing:
        return 'Breathing Exercises';
      case ResourceCategory.meditation:
        return 'Meditation';
      case ResourceCategory.selfHelp:
        return 'Self Help Tips';
    }
  }
}
