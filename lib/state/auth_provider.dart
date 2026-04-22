import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl();
});