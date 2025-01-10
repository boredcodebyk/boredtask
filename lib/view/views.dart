import 'package:flutter/material.dart';

export 'home.dart';
export 'task.dart';

export 'settings.dart';
// Settings Views
export 'settings_view/theme.dart';
export 'settings_view/appearance.dart';

Color colorScheme(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Theme.of(context).colorScheme.surfaceContainerLow
      : Theme.of(context).colorScheme.surfaceContainerHigh;
}

bool isDark(context) => Theme.of(context).brightness == Brightness.dark;

enum SettingList {
  theme(
    title: "Theme",
    route: '/settings/theme',
    icon: Icons.color_lens_outlined,
  ),
  appearance(
    title: "Appearance",
    route: '/settings/appearance',
    icon: Icons.list_alt,
  ),

  about(
    title: "Appearance",
    route: '/settings/appearance',
    icon: Icons.info_outline,
  );

  final String title;
  final String route;
  final IconData icon;
  const SettingList({
    required this.title,
    required this.route,
    required this.icon,
  });
}
