import 'package:design_system/theme/app_theme.dart';
import 'package:design_system/widgets/molecules/custom_text_field.dart';
import 'package:flutter/material.dart';

class InputDecorationThemeConfig {
  static InputDecorationTheme inputDecorationTheme(
    TextTheme textTheme,
    ColorScheme colorScheme, [
    TextFieldVariant? variant,
  ]) {
    return InputDecorationTheme(
      isDense: true,
      filled: variant == TextFieldVariant.filled,
      contentPadding: const EdgeInsets.fromLTRB(10, 12, 0, 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: colorScheme.outline)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
      fillColor: variant == TextFieldVariant.filled ? colorScheme.form : Colors.white,
    );
  }
}
