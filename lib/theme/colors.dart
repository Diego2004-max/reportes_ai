import 'package:flutter/material.dart';

/// Single source of truth for every color used in the app.
/// No hardcoded color values anywhere else in the codebase.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF0A5531); // Dark Forest Green
  static const Color primaryLight   = Color(0xFF1EA969); // Bright Green accent
  static const Color primaryDark    = Color(0xFF05381F);
  static const Color secondary      = Color(0xFF1E293B);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background     = Color(0xFFF2F6F9); // Light grayish blue
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE4EBFA); // Soft highlight

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF0F172A);
  static const Color textSecondary  = Color(0xFF64748B);
  static const Color textDisabled   = Color(0xFF94A3B8);
  static const Color textOnPrimary  = Color(0xFFFFFFFF);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color success        = Color(0xFF22C55E);
  static const Color successLight   = Color(0xFFDCFCE7);
  static const Color warning        = Color(0xFFF59E0B);
  static const Color warningLight   = Color(0xFFFEF3C7);
  static const Color error          = Color(0xFFEF4444);
  static const Color errorLight     = Color(0xFFFEE2E2);
  static const Color info           = Color(0xFF3B82F6);
  static const Color infoLight      = Color(0xFFEFF6FF);

  // ── Borders & Dividers ───────────────────────────────────────────────────
  static const Color border         = Color(0xFFE2E8F0);
  static const Color divider        = Color(0xFFF1F5F9);

  // ── Shadow ───────────────────────────────────────────────────────────────
  static const Color shadow         = Color(0x110F172A); // Very soft
  static const Color shadowMedium   = Color(0x1F0F172A); // Slightly stronger
}

/// Single source of truth for every spacing / sizing value.
abstract final class AppSpacing {
  static const double xs    = 4.0;
  static const double sm    = 8.0;
  static const double md    = 12.0;
  static const double lg    = 16.0;
  static const double xl    = 24.0;
  static const double xxl   = 32.0;
  static const double xxxl  = 40.0;
  static const double huge  = 56.0;

  // Modern Minimalist Border Radii (HUGE)
  static const double radiusSm  = 12.0;
  static const double radiusMd  = 16.0;
  static const double radiusLg  = 24.0;
  static const double radiusXl  = 32.0;
  static const double radiusXxl = 40.0;
  static const double radiusFull = 100.0;

  // Elevations (We want soft, almost flat UI)
  static const double elevationNone = 0;
  static const double elevationSm   = 1;
  static const double elevationMd   = 2;
  static const double elevationLg   = 4;

  // Horizontal screen padding
  static const double screenH = 24.0;

  // Heights
  static const double buttonHeight   = 56.0; // Thicker buttons
  static const double inputHeight    = 56.0;
  static const double appBarHeight   = 60.0;
  static const double bottomNavHeight = 72.0;
}
