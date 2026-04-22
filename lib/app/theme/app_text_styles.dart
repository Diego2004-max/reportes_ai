import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _base = TextStyle(
    fontFamily: 'Inter',
    color: AppColors.textPrimary,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static final display1 = _base.copyWith(fontSize: 32, fontWeight: FontWeight.w800, height: 1.2);
  static final display2 = _base.copyWith(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2);
  static final headline = _base.copyWith(fontSize: 24, fontWeight: FontWeight.w700, height: 1.35);
  static final titleLg  = _base.copyWith(fontSize: 22, fontWeight: FontWeight.w700, height: 1.35);
  static final titleMd  = _base.copyWith(fontSize: 16, fontWeight: FontWeight.w700, height: 1.35);
  static final bodyLg   = _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400, height: 1.65);
  static final bodyMd   = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.65);
  static final bodySm   = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5,  color: AppColors.textSecondary);
  static final labelLg  = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w700, height: 1.2);
  static final labelMd  = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2,  color: AppColors.textSecondary);
  static final labelSm  = _base.copyWith(fontSize: 11, fontWeight: FontWeight.w500, height: 1.2,  color: AppColors.textDisabled);
}
