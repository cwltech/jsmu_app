import 'package:jsmu/core/errors/app_exception.dart';
import 'package:jsmu/core/errors/failure.dart';
import 'package:jsmu/core/logger/app_logger.dart';
import 'package:jsmu/core/services/storage_service.dart';
import 'package:jsmu/core/services/token_storage_service.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  final TokenStorageService _tokenStorage;
  final StorageService _storageService;

  AuthRepository({
    AuthService? authService,
    TokenStorageService? tokenStorage,
    StorageService? storageService,
  }) : _authService = authService ?? AuthService(),
       _tokenStorage = tokenStorage ?? TokenStorageService(),
       _storageService = storageService ?? StorageService();

  Future<void> sendOtp(String phone) async {
    try {
      await _authService.sendOtp(phone);
    } catch (e) {
      AppLogger.error('AuthRepository sendOtp error: $e');
      throw Failure(e.toString());
    }
  }

  Future<UserModel> verifyOtp(String phone, String otp) async {
    try {
      final res = await _authService.verifyOtp(phone, otp);
      final token = res['token'] as String? ?? 'mock_token';
      await _tokenStorage.saveTokens(token: token);

      final userJson =
          res['user'] as Map<String, dynamic>? ??
          {
            'id': 'usr_1',
            'name': 'Priya Sharma',
            'phone': phone,
            'role': 'customer',
          };
      final user = UserModel.fromJson(userJson);
      await _storageService.setString('user_id', user.id);
      await _storageService.setString('user_name', user.name);
      await _storageService.setString('user_role', user.role);
      return user;
    } catch (e) {
      AppLogger.error('AuthRepository verifyOtp error: $e');
      throw Failure(e is AppException ? e.message : 'Invalid OTP entered');
    }
  }

  Future<void> signOut() async {
    await _tokenStorage.clearTokens();
    await _storageService.clear();
  }
}
