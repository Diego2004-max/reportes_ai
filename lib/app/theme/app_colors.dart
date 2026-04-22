import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF005EA4);
  static const Color primaryContainer = Color(0xFF1777C9);
  static const Color primaryLight = Color(0xFFD2E4FF); // primary-fixed
  
  static const Color secondary = Color(0xFF5C5E63);
  static const Color secondaryContainer = Color(0xFFDEDFE5);

  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Background and Surfaces
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F3FB);
  static const Color surfaceContainer = Color(0xFFECEEF5);
  static const Color surfaceContainerHigh = Color(0xFFE5E7EE);
  static const Color surfaceContainerHighest = Color(0xFFE0E2EA);
  static const Color surfaceVariant = Color(0xFFE0E2EA);

  // Text
  static const Color textPrimary = Color(0xFF181C21); // on-surface
  static const Color textSecondary = Color(0xFF414751); // on-surface-variant
  static const Color textDisabled = Color(0xFF717783); // outline
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Semantic Colors
  static const Color success = Color(0xFF1D9E75); 
  static const Color successLight = Color(0xFFE8F6F1); 
  
  static const Color warning = Color(0xFFEF9F27);
  static const Color warningLight = Color(0xFFFEF5E9);
  
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorLight = Color(0xFFFFDAD6); 
  
  static const Color info = Color(0xFF378ADD);
  static const Color infoLight = Color(0xFFE2EBF5);

  // Outline, Border & Dividers
  static const Color outline = Color(0xFF717783);
  static const Color border = Color(0xFFC0C7D3); 
  static const Color divider = Color(0xFFE0E2EA); 

  // Shadows (Ambient Shadows - Vial Lucid)
  static const Color shadow = Color(0x14000000); // 8% opacity, very soft
  static const Color shadowTint = Color(0xFFD6E4FF); // Soft blue tint for shadows
}