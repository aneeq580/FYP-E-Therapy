import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../core/widgets/resource_category_card.dart';

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
    },
    {
      'icon': FontAwesomeIcons.wind,
      'title': 'Breathing Exercises',
      'subtitle': 'Guided breathing techniques to help you relax and focus',
      'iconColor': AppColors.iconChat,
      'backgroundColor': AppColors.iconBgChat,
    },
    {
      'icon': FontAwesomeIcons.om,
      'title': 'Meditation',
      'subtitle': 'Mindfulness and meditation practices for inner peace',
      'iconColor': AppColors.iconMySessions,
      'backgroundColor': AppColors.iconBgMySessions,
    },
    {
      'icon': FontAwesomeIcons.lightbulb,
      'title': 'Self-help Tips',
      'subtitle': 'Practical tips and strategies for daily mental wellness',
      'iconColor': AppColors.iconMoodTracker,
      'backgroundColor': AppColors.iconBgMoodTracker,
    },
  ];

  void _handleCategoryTap(String category) {
    // TODO: Navigate to category detail screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CategoryDetailScreen(category: category),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Resources'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
        itemCount: resourceCategories.length,
        itemBuilder: (context, index) {
          final category = resourceCategories[index];
          return ResourceCategoryCard(
            icon: category['icon'] as IconData,
            title: category['title'] as String,
            subtitle: category['subtitle'] as String,
            iconColor: category['iconColor'] as Color,
            backgroundColor: category['backgroundColor'] as Color,
            onTap: () => _handleCategoryTap(category['title'] as String),
          );
        },
      ),
    );
  }
}
