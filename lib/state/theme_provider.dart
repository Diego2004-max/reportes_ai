import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/hive_boxes.dart';
import '../data/local/hive/hive_service.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final storedMode =
        HiveService.settingsBox.get(HiveKeys.themeMode) as String?;
    return _parseThemeMode(storedMode);
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