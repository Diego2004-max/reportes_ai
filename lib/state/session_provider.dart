import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/hive_boxes.dart';
import '../data/local/hive/hive_service.dart';

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);

class SessionState {
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? userName;

  const SessionState({
    required this.isAuthenticated,
    this.userId,
    this.email,
    this.userName,
  });

  factory SessionState.initial() {
    return const SessionState(isAuthenticated: false);
  }

  SessionState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? userName,
  }) {
    return SessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
    );
  }
}

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() {
    final box = HiveService.sessionBox;

    final isLoggedIn =
        (box.get(HiveKeys.isLoggedIn, defaultValue: false) as bool?) ?? false;

    return SessionState(
      isAuthenticated: isLoggedIn,
      userId: box.get(HiveKeys.userId) as String?,
      email: box.get(HiveKeys.userEmail) as String?,
      userName: box.get(HiveKeys.userName) as String?,
    );
  }

  Future<void> saveLocalSession({
    required String userId,
    required String email,
    required String userName,
  }) async {
    await HiveService.sessionBox.put(HiveKeys.isLoggedIn, true);
    await HiveService.sessionBox.put(HiveKeys.userId, userId);
    await HiveService.sessionBox.put(HiveKeys.userEmail, email);
    await HiveService.sessionBox.put(HiveKeys.userName, userName);

    state = SessionState(
      isAuthenticated: true,
      userId: userId,
      email: email,
      userName: userName,
    );
  }

  Future<void> clearSession() async {
    await HiveService.clearSession();
    state = SessionState.initial();
  }

  Future<void> updateUserName(String userName) async {
    await HiveService.sessionBox.put(HiveKeys.userName, userName);
    
    state = state.copyWith(userName: userName);
  }
}