import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../../routes/app_routes.dart';

class PatientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool showDefaultActions;

  const PatientAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.showDefaultActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title:
          titleWidget ??
          Text(
            title ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: AppColors.primary),
      ),
      actions:
          actions ??
          (showDefaultActions
              ? [
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.bell,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.toNamed(AppRoutes.patientReports);
                    },
                  ),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.circleUser,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.toNamed(AppRoutes.patientProfile);
                    },
                  ),
                  const SizedBox(width: 8),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
