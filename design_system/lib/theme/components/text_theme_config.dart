import 'package:design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TextThemeConfig {
  static TextTheme textTheme(ColorScheme colorScheme) {
    return TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.mainText),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: colorScheme.mainText),
      titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.mainText),
      bodyLarge: TextStyle(fontSize: 17, color: colorScheme.mainText),
      bodyMedium: TextStyle(fontSize: 15, color: colorScheme.mainText),
      bodySmall: TextStyle(fontSize: 13, color: colorScheme.mainText),
    );
  }
}
