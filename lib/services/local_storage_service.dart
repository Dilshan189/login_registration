import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _keyRememberMe = 'remember_me';
  static const String _keySavedIdentifier = 'saved_identifier';
  static const String _keyUserSession = 'user_session';
  static const String _keyAuthToken = 'auth_token';

  /// Save Remember Me preference and identifier
  static Future<void> saveRememberMe({
    required bool rememberMe,
    required String identifier,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, rememberMe);
    if (rememberMe) {
      await prefs.setString(_keySavedIdentifier, identifier);
    } else {
      await prefs.remove(_keySavedIdentifier);
    }
  }

  /// Get Remember Me status
  static Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  /// Get Saved Identifier (Email/Mobile)
  static Future<String?> getSavedIdentifier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySavedIdentifier);
  }

  /// Save logged in user session
  static Future<void> saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserSession, jsonEncode(user.toJson()));
    if (user.token != null) {
      await prefs.setString(_keyAuthToken, user.token!);
    }
  }

  /// Get current cached user session
  static Future<UserModel?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonStr = prefs.getString(_keyUserSession);
    if (userJsonStr == null || userJsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(userJsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Clear active session on logout
  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserSession);
    await prefs.remove(_keyAuthToken);
  }
}

