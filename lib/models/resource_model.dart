import 'package:flutter/material.dart';

enum ResourceCategory {
  articles,
  breathing,
  meditation,
  selfHelp,
}

class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final ResourceCategory category;
  final String? imageUrl;
  final IconData? icon;
  final Duration? duration; // For breathing/meditation
  final String? tag; // e.g. "Anxiety", "Wellness"
  final String? readTime; // e.g. "5 min read"
  final double? rating; // e.g. 4.8
  final Color? color; // Background color for the card
  final Color? tagColor; // Background color for the tag/topic
  final String? difficulty; // e.g. "Beginner", "Intermediate"
  final String? benefits; // e.g. "Reduces anxiety, lowers heart rate..."
  final List<String>? steps; // Step-by-step instructions
  final Color? topBorderColor; // For breathing exercise cards

  const ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    this.imageUrl,
    this.icon,
    this.duration,
    this.tag,
    this.readTime,
    this.rating,
    this.color,
    this.tagColor,
    this.difficulty,
    this.benefits,
    this.steps,
    this.topBorderColor,
  });
}
