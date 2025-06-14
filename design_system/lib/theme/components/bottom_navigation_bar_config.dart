import 'package:flutter/material.dart';

class BottomNavigationBarThemeConfig {
  static BottomNavigationBarThemeData bottomNavigationBarThemeData(ColorScheme colorScheme) {
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Color(0xFF9FA5C0),
      type: BottomNavigationBarType.fixed,
    );
  }
}
