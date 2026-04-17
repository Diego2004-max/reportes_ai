import 'package:uuid/uuid.dart';

import 'package:reportes_ai/data/local/hive/hive_service.dart';
import 'package:reportes_ai/data/models/user_model.dart';

class AuthRepositoryImpl {
  final Uuid _uuid = const Uuid();

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    for (final raw in HiveService.usersBox.values) {
      final user = UserModel.fromMap(Map<String, dynamic>.from(raw as Map));
      if (user.email.toLowerCase() == normalizedEmail) {
        throw Exception('Ese correo ya está registrado');
      }
    }

    final user = UserModel(
      id: _uuid.v4(),
      fullName: fullName.trim(),
      email: normalizedEmail,
      password: password,
      createdAt: DateTime.now(),
    );

    await HiveService.usersBox.put(user.id, user.toMap());
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    for (final raw in HiveService.usersBox.values) {
      final user = UserModel.fromMap(Map<String, dynamic>.from(raw as Map));
      if (user.email.toLowerCase() == normalizedEmail &&
          user.password == password) {
        return user;
      }
    }

    throw Exception('Correo o contraseña incorrectos');
  }

  Future<UserModel?> getUserById(String userId) async {
    final raw = HiveService.usersBox.get(userId);
    if (raw == null) return null;

    return UserModel.fromMap(Map<String, dynamic>.from(raw as Map));
  }

  Future<UserModel> updateUserName({
    required String userId,
    required String newName,
  }) async {
    final current = await getUserById(userId);
    if (current == null) {
      throw Exception('Usuario no encontrado');
    }

    final updated = UserModel(
      id: current.id,
      fullName: newName.trim(),
      email: current.email,
      password: current.password,
      createdAt: current.createdAt,
    );

    await HiveService.usersBox.put(updated.id, updated.toMap());
    return updated;
  }
}