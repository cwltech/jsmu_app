import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jsmu/core/errors/failure.dart';

import '../models/dispatch_lead_model.dart';
import '../models/partner_dashboard_model.dart';
import '../models/partner_wallet_model.dart';
import '../repositories/partner_repository.dart';

class PartnerProvider extends ChangeNotifier {
  final PartnerRepository _repository;

  PartnerProvider({PartnerRepository? repository})
    : _repository = repository ?? PartnerRepository();

  bool _isLoading = false;
  String? _errorMessage;

  DispatchLeadModel? _dispatchLead;
  PartnerDashboardModel? _dashboard;
  PartnerWalletModel? _wallet;

  bool _isOnline = true;
  int _countdownSeconds = 37;
  Timer? _countdownTimer;
  int _activePartnerNav = 0; // 0: Radar, 1: Schedule, 2: Earnings, 3: Profile

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DispatchLeadModel? get dispatchLead => _dispatchLead;
  PartnerDashboardModel? get dashboard => _dashboard;
  PartnerWalletModel? get wallet => _wallet;
  bool get isOnline => _isOnline;
  int get countdownSeconds => _countdownSeconds;
  int get activePartnerNav => _activePartnerNav;

  void setActivePartnerNav(int index) {
    if (_activePartnerNav != index) {
      _activePartnerNav = index;
      notifyListeners();
    }
  }

  void toggleOnlineStatus() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  Future<void> fetchDispatchLead() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dispatchLead = await _repository.getDispatchLead();
      _countdownSeconds = _dispatchLead?.countdownSeconds ?? 37;
      _startTimer();
      _isLoading = false;
      notifyListeners();
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load dispatch lead';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        notifyListeners();
      } else {
        _countdownTimer?.cancel();
      }
    });
  }

  Future<void> fetchDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboard = await _repository.getDashboard();
      _isOnline = _dashboard?.isOnline ?? true;
      _isLoading = false;
      notifyListeners();
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load dashboard';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWallet() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallet = await _repository.getWallet();
      _isLoading = false;
      notifyListeners();
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load wallet';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
