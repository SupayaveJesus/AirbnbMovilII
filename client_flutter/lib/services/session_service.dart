import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_result.dart';
import '../models/user_model.dart';

class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  Future<bool> hasActiveSession() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.containsKey(_userKey) ||
        preferences.containsKey(_tokenKey);
  }

  Future<UserModel?> currentUser() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_userKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(AuthResult result) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_userKey, jsonEncode(result.user.toJson()));
    if (result.token.isNotEmpty) {
      await preferences.setString(_tokenKey, result.token);
    }
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userKey);
    await preferences.remove(_tokenKey);
  }
}
