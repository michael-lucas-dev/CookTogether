import 'package:design_system/widgets/atoms/buttons/enums.dart';
import 'package:flutter/material.dart';

class ButtonThemeConfig {
  static ElevatedButtonThemeData elevatedButtonThemeData(
    TextTheme theme,
    ColorScheme colorScheme, [
    ButtonVariant? variant,
  ]) {
    return ElevatedButtonThemeData(style: buttonStyle(colorScheme, variant));
  }

  static OutlinedButtonThemeData outlinedButtonThemeData(
    TextTheme theme,
    ColorScheme colorScheme, [
    ButtonVariant? variant,
  ]) {
    return OutlinedButtonThemeData(style: buttonStyle(colorScheme, variant));
  }

  static TextButtonThemeData textButtonThemeData(
    TextTheme theme,
    ColorScheme colorScheme, [
    ButtonVariant? variant,
  ]) {
    return TextButtonThemeData(style: buttonStyle(colorScheme, variant));
  }

  static ButtonStyle buttonStyle(ColorScheme colorScheme, ButtonVariant? variant) {
    final mainColor =
        variant?.color == ColorVariant.primary ? colorScheme.primary : colorScheme.secondary;
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(mainColor),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
    );
  }
}
