import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/hive_boxes.dart';

abstract final class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await _openCoreBoxes();
  }

  static Future<void> _openCoreBoxes() async {
    await Future.wait([
      Hive.openBox(HiveBoxes.settings),
      Hive.openBox(HiveBoxes.session),
      Hive.openBox(HiveBoxes.users),
      Hive.openBox(HiveBoxes.reports),
      Hive.openBox(HiveBoxes.reportDrafts),
      Hive.openBox(HiveBoxes.reportCache),
    ]);
  }

  static Box<dynamic> get settingsBox => Hive.box(HiveBoxes.settings);
  static Box<dynamic> get sessionBox => Hive.box(HiveBoxes.session);
  static Box<dynamic> get usersBox => Hive.box(HiveBoxes.users);
  static Box<dynamic> get reportsBox => Hive.box(HiveBoxes.reports);
  static Box<dynamic> get reportDraftsBox => Hive.box(HiveBoxes.reportDrafts);
  static Box<dynamic> get reportCacheBox => Hive.box(HiveBoxes.reportCache);

  static Future<void> clearSession() async {
    await sessionBox.clear();
  }
}