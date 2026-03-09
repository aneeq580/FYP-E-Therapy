import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../profile/settings_tile.dart';

class SettingsCard extends StatelessWidget {
  final List<SettingsTile> tiles;
  final String title;

  const SettingsCard({super.key, required this.tiles, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1),
          // Interleave tiles with Dividers
          ...tiles.expand((tile) {
            final isLast = tile == tiles.last;
            return [tile, if (!isLast) const Divider(height: 1, indent: 50)];
          }),
        ],
      ),
    );
  }
}
