import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Central icon widget that uses FontAwesome icons.
///
/// Replace inline `Icon(...)` usages with `AppIcon(FontAwesomeIcons.whatever)`
/// to keep icon styling consistent across the app.
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const AppIcon(this.icon, {super.key, this.size = 10, this.color});

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      icon,
      size: size,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }
}
