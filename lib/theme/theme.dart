import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Builds the Material Design 3 theme for the Reportes AI app.
/// Every design token is derived from [AppColors] and [AppSpacing].
abstract final class AppTheme {
  // ── Private helpers ───────────────────────────────────────────────────────

  static ColorScheme get _colorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.infoLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnPrimary,
        secondaryContainer: AppColors.surfaceVariant,
        onSecondaryContainer: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.background,
        onSurfaceVariant: AppColors.textSecondary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.error,
        outline: AppColors.border,
        outlineVariant: AppColors.divider,
        shadow: AppColors.shadow,
        scrim: AppColors.shadow,
      );

  // ── Typography ────────────────────────────────────────────────────────────

  /// Full text-style set using Inter from Google Fonts.
  static TextTheme get _textTheme => GoogleFonts.interTextTheme(
        const TextTheme(
          // Display — hero / large numerics
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
            color: AppColors.textPrimary,
            height: 1.12,
          ),
          // Headline — screen titles
          headlineMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
            height: 1.25,
          ),
          // Title — card headers, section labels
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
            height: 1.27,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: AppColors.textPrimary,
            height: 1.50,
          ),
          // Body — paragraph text
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            color: AppColors.textPrimary,
            height: 1.50,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: AppColors.textSecondary,
            height: 1.43,
          ),
          // Label — buttons, badges, chips
          labelLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            color: AppColors.textPrimary,
            height: 1.43,
          ),
          labelMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: AppColors.textSecondary,
            height: 1.33,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.textDisabled,
            height: 1.45,
          ),
        ),
      );

  // ── Shapes ────────────────────────────────────────────────────────────────

  static RoundedRectangleBorder _roundedBorder(double radius) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      );

  // ── Public theme ──────────────────────────────────────────────────────────

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        scaffoldBackgroundColor: AppColors.background,
        splashColor: AppColors.primaryLight.withAlpha(20),
        highlightColor: Colors.transparent,

        // ── AppBar ──────────────────────────────────────────────────────────
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: AppSpacing.elevationNone,
          scrolledUnderElevation: AppSpacing.elevationNone,
          shadowColor: AppColors.shadow,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          surfaceTintColor: Colors.transparent,
        ),

        // ── Card ────────────────────────────────────────────────────────────
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: AppSpacing.elevationNone,
          shadowColor: AppColors.shadowMedium,
          surfaceTintColor: Colors.transparent,
          shape: _roundedBorder(AppSpacing.radiusXl),
          margin: EdgeInsets.zero,
        ),

        // ── Input ───────────────────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide:
                const BorderSide(color: AppColors.error, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintStyle: const TextStyle(color: AppColors.textDisabled),
          errorStyle:
              const TextStyle(color: AppColors.error, fontSize: 12),
          prefixIconColor: AppColors.textSecondary,
          suffixIconColor: AppColors.textSecondary,
        ),

        // ── ElevatedButton ─────────────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: AppSpacing.elevationNone,
            minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
            shape: _roundedBorder(AppSpacing.radiusXxl),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),

        // ── OutlinedButton ─────────────────────────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 2),
            minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
            shape: _roundedBorder(AppSpacing.radiusXxl),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),

        // ── TextButton ─────────────────────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // ── Chip ───────────────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surface,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        ),

        // ── NavigationBar (MD3) ────────────────────────────────────────────
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: Colors.transparent, // NAKED ICONS
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary, size: 26);
            }
            return const IconThemeData(
                color: AppColors.textDisabled, size: 26);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary);
            }
            return GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textDisabled);
          }),
          elevation: AppSpacing.elevationNone,
          shadowColor: AppColors.shadowMedium,
          surfaceTintColor: Colors.transparent,
        ),

        // ── Divider ────────────────────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 0,
        ),

        // ── FloatingActionButton ───────────────────────────────────────────
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          elevation: AppSpacing.elevationLg,
          shape: _roundedBorder(AppSpacing.radiusFull),
        ),

        // ── SnackBar ───────────────────────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.secondary,
          contentTextStyle: const TextStyle(color: AppColors.textOnPrimary),
          shape: _roundedBorder(AppSpacing.radiusLg),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
