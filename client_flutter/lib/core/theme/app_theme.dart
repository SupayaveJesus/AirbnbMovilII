import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B1326);
  static const Color backgroundSoft = Color(0xFF131B2E);
  static const Color surface = Color(0xB3273148);
  static const Color border = Color(0x33FFFFFF);
  static const Color primary = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color danger = Color(0xFFF43F5E);

  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
      surface: backgroundSoft,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
      ),
    );
  }

  static BoxDecoration glassBoxDecoration({
    bool highlighted = false,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: highlighted ? 0.16 : 0.12),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
      border: Border.all(
        color: highlighted ? secondary.withValues(alpha: 0.55) : border,
      ),
      boxShadow: [
        BoxShadow(
          color: (highlighted ? primary : Colors.black).withValues(alpha: 0.18),
          blurRadius: highlighted ? 30 : 18,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.highlighted = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: AppTheme.glassBoxDecoration(
            highlighted: highlighted,
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
