import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

class AvatarSelectionModal extends StatelessWidget {
  final Function(String) onSelect;
  final String gender;

  const AvatarSelectionModal({
    super.key,
    required this.onSelect,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> avatars = [
      'assets/images/avatar_man_1.png',
      'assets/images/avatar_woman_1.png',
      'assets/images/avatar_man_2.png',
      'assets/images/avatar_woman_2.png',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.spacingLarge,
        horizontal: AppSizes.spacingMedium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          Text(
            'Select Avatar',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          SizedBox(
            height: 250,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSizes.spacingMedium,
                mainAxisSpacing: AppSizes.spacingMedium,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                final url = avatars[index];

                return GestureDetector(
                  onTap: () {
                    onSelect(url);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: url.startsWith('http')
                          ? Image.network(
                              url,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person);
                              },
                            )
                          : Image.asset(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person);
                              },
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
