import 'package:flutter/material.dart';
import 'package:jsmu/core/errors/failure.dart';
import 'package:jsmu/core/logger/app_logger.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  bool _isLoading = false;
  bool _isOtpSent = false;
  String? _errorMessage;
  UserModel? _currentUser;
  String _selectedRole = 'customer'; // 'customer' or 'partner'

  bool get isLoading => _isLoading;
  bool get isOtpSent => _isOtpSent;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  String get selectedRole => _selectedRole;
  bool get isAuthenticated => _currentUser != null;

  void setSelectedRole(String role) {
    if (_selectedRole != role) {
      _selectedRole = role;
      notifyListeners();
    }
  }

  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.sendOtp(phone);
      _isOtpSent = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to send OTP. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.verifyOtp(phone, otp);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Verification failed. Please check the code.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerCustomer({
    required String name,
    required String phone,
    required String email,
    required String location,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim().isEmpty ? 'Priya Sharma' : name.trim(),
        phone: phone.trim().isEmpty ? '98765 43210' : phone.trim(),
        email: email.trim().isEmpty ? 'priya.sharma@example.com' : email.trim(),
        location: location.trim().isEmpty ? 'Gurgaon • DLF Phase 4' : location.trim(),
        role: 'customer',
        isVerified: true,
      );
      _selectedRole = 'customer';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _currentUser = null;
    _isOtpSent = false;
    notifyListeners();
  }

  void updateUserLocation(String newLocation) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(location: newLocation);
    } else {
      _currentUser = UserModel(
        id: 'usr_guest',
        name: 'Priya Sharma',
        phone: '+91 98765 43210',
        email: 'priya.sharma@example.com',
        location: newLocation,
        role: _selectedRole,
      );
    }
    notifyListeners();
  }

  void resetState() {
    _isLoading = false;
    _isOtpSent = false;
    _errorMessage = null;
    notifyListeners();
  }
}
