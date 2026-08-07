import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// EXPRESSIVE LIGHT THEME
/// ------------------------------------------------------------
ThemeData buildExpressiveLightTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: const Color(0xFF4F8CFF), // expressive blue
  );

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFFF7F7F9),

    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    textTheme: base.textTheme.copyWith(
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Colors.black87,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.black87,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.black87,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),

    visualDensity: VisualDensity.standard,
  );
}

/// ------------------------------------------------------------
/// EXPRESSIVE DARK THEME
/// ------------------------------------------------------------
ThemeData buildExpressiveDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: const Color(0xFF4F8CFF),
  );

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFF0F0F12),

    cardTheme: const CardThemeData(
      color: Color(0xFF1A1A1E),
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    textTheme: base.textTheme.copyWith(
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Colors.white,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.white70,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.white70,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),

    visualDensity: VisualDensity.standard,
  );
}
