import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/app.dart';
import 'package:reportes_ai/data/local/hive/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(
    const ProviderScope(
      child: AiReportsApp(),
    ),
  );
}