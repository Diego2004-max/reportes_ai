import 'package:flutter/material.dart';

/// Single source of truth for every color used in the app.
/// No hardcoded color values anywhere else in the codebase.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF2563EB);
  static const Color primaryLight   = Color(0xFF3B82F6);
  static const Color primaryDark    = Color(0xFF1D4ED8);
  static const Color secondary      = Color(0xFF1E293B);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background     = Color(0xFFF1F5F9);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE2E8F0);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF0F172A);
  static const Color textSecondary  = Color(0xFF475569);
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
  static const Color shadow         = Color(0x1A0F172A); // 10 % textPrimary
  static const Color shadowMedium   = Color(0x260F172A); // 15 % textPrimary
}

/// Single source of truth for every spacing / sizing value.
abstract final class AppSpacing {
  static const double xs    = 4.0;
  static const double sm    = 8.0;
  static const double md    = 12.0;
  static const double lg    = 16.0;
  static const double xl    = 20.0;
  static const double xxl   = 24.0;
  static const double xxxl  = 32.0;
  static const double huge  = 48.0;

  // Border radii
  static const double radiusSm  = 8.0;
  static const double radiusMd  = 12.0;
  static const double radiusLg  = 16.0;
  static const double radiusXl  = 20.0;
  static const double radiusFull = 100.0;

  // Elevations
  static const double elevationNone = 0;
  static const double elevationSm   = 1;
  static const double elevationMd   = 2;
  static const double elevationLg   = 4;

  // Horizontal screen padding
  static const double screenH = 20.0;

  // Heights
  static const double buttonHeight   = 52.0;
  static const double inputHeight    = 56.0;
  static const double appBarHeight   = 60.0;
  static const double bottomNavHeight = 64.0;
}
