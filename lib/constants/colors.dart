import 'package:flutter/material.dart';

class AppColors {
  // Your Dark Theme Colors
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0x1AFFFFFF);
  static const Color primary = Color(0xFFFAE208);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF);
  static const Color emoji = Color(0xFFFAE208);
  static const Color success = Color(0xFF4CD964);
  static const Color warning = Color(0xFFFFCC00);
  static const Color error = Color(0xFFFF3B30);
  
  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0x1AFAE208), Color(0x1A00D8FF)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const Gradient successGradient = LinearGradient(
    colors: [Color(0x1A4CD964), Color(0x1A00D8FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: 1.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );
}