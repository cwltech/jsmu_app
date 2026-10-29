import 'package:flutter/material.dart';
import 'package:jsmu/core/errors/failure.dart';

import '../models/tracking_status_model.dart';
import '../repositories/tracking_repository.dart';

class TrackingProvider extends ChangeNotifier {
  final TrackingRepository _repository;

  TrackingProvider({TrackingRepository? repository})
    : _repository = repository ?? TrackingRepository();

  bool _isLoading = false;
  String? _errorMessage;
  TrackingStatusModel? _tracking;
  bool _isBreakdownExpanded = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TrackingStatusModel? get tracking => _tracking;
  bool get isBreakdownExpanded => _isBreakdownExpanded;

  void toggleBreakdown() {
    _isBreakdownExpanded = !_isBreakdownExpanded;
    notifyListeners();
  }

  Future<void> fetchTracking([String bookingId = 'HS-89421']) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tracking = await _repository.getLiveStatus(bookingId);
      _isLoading = false;
      notifyListeners();
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load tracking updates';
      _isLoading = false;
      notifyListeners();
    }
  }
}
