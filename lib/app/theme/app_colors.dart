import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── PRIMARY (forest green) ────────────────────────────────
  static const Color primary        = Color(0xFF0A5531);
  static const Color primaryLight   = Color(0xFF1EA969);
  static const Color primaryDark    = Color(0xFF05381F);
  static const Color primarySoft    = Color(0xFFDDF7EA);
  static const Color primaryBadge   = Color(0x140A5531); // rgba(10,85,49,0.08)

  // ── SECONDARY ─────────────────────────────────────────────
  static const Color secondary      = Color(0xFF1E293B);

  // ── BACKGROUNDS ───────────────────────────────────────────
  static const Color background             = Color(0xFFF5F7FB);
  static const Color surface                = Color(0xFFFFFFFF);
  static const Color surfaceVariant         = Color(0xFFE4EBFA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow    = Color(0xFFF5F7FB);
  static const Color surfaceContainer       = Color(0xFFE4EBFA);
  static const Color surfaceContainerHigh   = Color(0xFFD8E1F5);
  static const Color surfaceContainerHighest= Color(0xFFCFD9F0);

  // ── TEXT ──────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF0F172A);
  static const Color textSecondary  = Color(0xFF64748B);
  static const Color textDisabled   = Color(0xFF94A3B8);
  static const Color textOnPrimary  = Color(0xFFFFFFFF);

  // keep alias used in screens
  static const Color onPrimary      = textOnPrimary;

  // ── SEMANTIC ──────────────────────────────────────────────
  static const Color success        = Color(0xFF22C55E);
  static const Color successLight   = Color(0xFFDCFCE7);
  static const Color warning        = Color(0xFFF59E0B);
  static const Color warningLight   = Color(0xFFFEF3C7);
  static const Color error          = Color(0xFFEF4444);
  static const Color errorLight     = Color(0xFFFEE2E2);
  static const Color info           = Color(0xFF3B82F6);
  static const Color infoLight      = Color(0xFFEFF6FF);

  // ── BORDERS / DIVIDERS ────────────────────────────────────
  static const Color border         = Color(0xFFE2E8F0);
  static const Color divider        = Color(0xFFF1F5F9);
  static const Color outline        = Color(0xFF94A3B8);

  // ── SHADOWS ───────────────────────────────────────────────
  static const Color shadow         = Color(0x0A0F172A); // very soft neutral
  static const Color shadowTint     = Color(0x000F172A); // transparent — no blue tint

  // ── DARK MODE ─────────────────────────────────────────────
  static const Color darkBg             = Color(0xFF101827);
  static const Color darkSurface        = Color(0xFF162133);
  static const Color darkSurfaceVariant = Color(0xFF1B2940);
  static const Color darkBorder         = Color(0xFF2A3A52);
  static const Color darkDivider        = Color(0xFF1F2F45);
  static const Color darkPrimary        = Color(0xFF2FBF71);
  static const Color darkTextPrimary    = Color(0xFFF8FAFC);
  static const Color darkTextSecondary  = Color(0xFFB7C3D4);
  static const Color darkTextDisabled   = Color(0xFF8EA0B7);
}
