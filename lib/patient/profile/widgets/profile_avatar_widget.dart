import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/colors.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? profileImageUrl;
  final String displayName;
  final String gender;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditTap;

  const ProfileAvatarWidget({
    super.key,
    this.profileImageUrl,
    required this.displayName,
    required this.gender,
    this.onAvatarTap,
    this.onEditTap,
  });

  String _getFallbackAvatarUrl() {
    final seed = displayName.isNotEmpty ? displayName : 'User';

    // notionists provides a clean, professional half-body avatar
    return 'https://api.dicebear.com/7.x/notionists/png?seed=${Uri.encodeComponent(seed)}&backgroundColor=e0f2fe';
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp('\\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _initialsAvatar(String name, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: Center(
        child: Text(
          _initials(name),
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: width * 0.36,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveImageUrl =
        (profileImageUrl != null && profileImageUrl!.isNotEmpty)
        ? profileImageUrl!
        : _getFallbackAvatarUrl();

    const double width = 120.0;
    const double height = 120.0;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: effectiveImageUrl.startsWith('assets/')
                  ? Image.asset(
                      effectiveImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _initialsAvatar(displayName, width, height);
                      },
                    )
                  : Image.network(
                      effectiveImageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _initialsAvatar(displayName, width, height);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _initialsAvatar(displayName, width, height);
                      },
                    ),
            ),
          ),
        ),

        // Edit Icon Container
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.backgroundLight, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.pen,
                size: 16,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
