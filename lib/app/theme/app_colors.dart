import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF22C55E);
  static const Color primaryLight = Color(0xFF4ADE80);
  static const Color primaryDark = Color(0xFF15803D);
  static const Color secondary = Color(0xFF0F172A);

  // Light surfaces
  static const Color background = Color(0xFFF4F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Dark surfaces
  static const Color darkBackground = Color(0xFF08111F);
  static const Color darkSurface = Color(0xFF0F1B2D);
  static const Color darkSurfaceVariant = Color(0xFF162338);

  // Text light
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Text dark
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF94A3B8);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE5EAF2);
  static const Color darkBorder = Color(0xFF22324B);
  static const Color darkDivider = Color(0xFF1E2C43);

  // Shadows
  static const Color shadow = Color(0x140F172A);
  static const Color shadowMedium = Color(0x220F172A);
}