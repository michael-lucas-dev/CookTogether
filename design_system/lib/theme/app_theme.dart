import 'package:design_system/theme/components/bottom_navigation_bar_config.dart';
import 'package:design_system/theme/components/button_theme_config.dart';
import 'package:design_system/theme/components/input_decoration_theme_config.dart';
import 'package:design_system/theme/components/text_theme_config.dart';
import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get mainText => Color(0xFF2E3E5C);
  Color get secondaryText => Color(0xFF24D37F);
  Color get outline => Color(0xFFD0DBEA);
  Color get form => Color(0xFFF4F5F7);
}

class AppTheme {
  AppTheme._();

  static ThemeData _createTheme(Brightness brightness) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: const Color(0xFF1FCC79),
      secondary: const Color(0xFF24D37F),
      error: const Color(0xFF24D37F),
    );
    final TextTheme textTheme = TextThemeConfig.textTheme(colorScheme);

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      elevatedButtonTheme: ButtonThemeConfig.elevatedButtonThemeData(textTheme, colorScheme),
      outlinedButtonTheme: ButtonThemeConfig.outlinedButtonThemeData(textTheme, colorScheme),
      textButtonTheme: ButtonThemeConfig.textButtonThemeData(textTheme, colorScheme),
      inputDecorationTheme: InputDecorationThemeConfig.inputDecorationTheme(textTheme, colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeConfig.bottomNavigationBarThemeData(
        colorScheme,
      ),
    );
  }

  static ThemeData get lightTheme => _createTheme(Brightness.light);

  static ThemeData get darkTheme => _createTheme(Brightness.dark);

  static ThemeData dark() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      // Personnalisation du thème sombre
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50),
        brightness: Brightness.dark,
      ),
    );
  }
}
