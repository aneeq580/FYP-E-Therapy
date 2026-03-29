import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/patient_app_bar.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/resource_category_card.dart';
import '../../models/resource_model.dart';
import 'resource_list_screen.dart';

/// Resources Screen - Display mental health resources and self-help content
class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  // Resource categories data
  static const List<Map<String, dynamic>> resourceCategories = [
    {
      'icon': FontAwesomeIcons.newspaper,
      'title': 'Articles',
      'subtitle': 'Read helpful articles about mental health and wellness',
      'iconColor': AppColors.iconBookSession,
      'backgroundColor': AppColors.iconBgBookSession,
      'category': ResourceCategory.articles,
    },
    {
      'icon': FontAwesomeIcons.wind,
      'title': 'Breathing Exercises',
      'subtitle': 'Guided breathing techniques to help you relax and focus',
      'iconColor': AppColors.iconResources,
      'backgroundColor': AppColors.iconBgResources,
      'category': ResourceCategory.breathing,
    },
    {
      'icon': FontAwesomeIcons.om,
      'title': 'Meditation',
      'subtitle': 'Mindfulness and meditation practices for inner peace',
      'iconColor': AppColors.iconMySessions,
      'backgroundColor': AppColors.iconBgMySessions,
      'category': ResourceCategory.meditation,
    },
    {
      'icon': FontAwesomeIcons.lightbulb,
      'title': 'Self-help Tips',
      'subtitle': 'Practical tips and strategies for daily mental wellness',
      'iconColor': AppColors.iconMoodTracker,
      'backgroundColor': AppColors.iconBgMoodTracker,
      'category': ResourceCategory.selfHelp,
    },
  ];

  void _handleCategoryTap(BuildContext context, String title, ResourceCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResourceListScreen(
          title: title,
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PatientAppBar(title: 'Resources'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
        itemCount: resourceCategories.length,
        itemBuilder: (context, index) {
          final categoryData = resourceCategories[index];
          return ResourceCategoryCard(
            icon: categoryData['icon'] as IconData,
            title: categoryData['title'] as String,
            subtitle: categoryData['subtitle'] as String,
            iconColor: categoryData['iconColor'] as Color,
            backgroundColor: categoryData['backgroundColor'] as Color,
            onTap: () => _handleCategoryTap(
              context,
              categoryData['title'] as String,
              categoryData['category'] as ResourceCategory,
            ),
          );
        },
      ),
    );
  }
}
