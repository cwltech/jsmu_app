import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logger/app_logger.dart';

class TokenStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static String? _inMemoryToken;
  static String? _inMemoryRefreshToken;

  Future<void> saveTokens({required String token, String? refreshToken}) async {
    _inMemoryToken = token;
    _inMemoryRefreshToken = refreshToken;
    try {
      await _secureStorage.write(key: _authTokenKey, value: token);
      if (refreshToken != null) {
        await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      }
    } catch (e) {
      AppLogger.error('FlutterSecureStorage write failed, falling back to SharedPreferences: $e');
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_authTokenKey, token);
        if (refreshToken != null) {
          await prefs.setString(_refreshTokenKey, refreshToken);
        }
      } catch (_) {}
    }
  }

  Future<String?> getToken() async {
    if (_inMemoryToken != null) return _inMemoryToken;
    try {
      final token = await _secureStorage.read(key: _authTokenKey);
      if (token != null) return token;
    } catch (e) {
      AppLogger.error('FlutterSecureStorage read failed: $e');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_authTokenKey);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    if (_inMemoryRefreshToken != null) return _inMemoryRefreshToken;
    try {
      final token = await _secureStorage.read(key: _refreshTokenKey);
      if (token != null) return token;
    } catch (e) {
      AppLogger.error('FlutterSecureStorage read refresh failed: $e');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearTokens() async {
    _inMemoryToken = null;
    _inMemoryRefreshToken = null;
    try {
      await _secureStorage.delete(key: _authTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await prefs.remove(_refreshTokenKey);
    } catch (_) {}
  }
}
