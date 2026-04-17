import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/hive_boxes.dart';
import '../data/local/hive/hive_service.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier()..loadTheme();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final storedMode =
        HiveService.settingsBox.get(HiveKeys.themeMode) as String?;
    state = _parseThemeMode(storedMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await HiveService.settingsBox.put(HiveKeys.themeMode, mode.name);
  }

  Future<void> toggleLightDark() async {
    final nextMode =
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }

  ThemeMode _parseThemeMode(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}