import 'package:flutter/material.dart';
import 'package:jsmu/core/errors/failure.dart';

import '../models/booking_model.dart';
import '../repositories/booking_repository.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _repository;

  BookingProvider({BookingRepository? repository})
    : _repository = repository ?? BookingRepository();

  bool _isLoading = false;
  String? _errorMessage;
  int _selectedDateIndex = 0;
  String _selectedTimeSlot = '10:00 AM';
  final String _appliedPromo = 'WELCOME20';
  num _itemTotal = 599;
  final num _convenienceFee = 29;
  num _discount = 120;
  BookingModel? _latestBooking;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedDateIndex => _selectedDateIndex;
  String get selectedTimeSlot => _selectedTimeSlot;
  String get appliedPromo => _appliedPromo;
  num get itemTotal => _itemTotal;
  num get convenienceFee => _convenienceFee;
  num get discount => _discount;
  num get totalPayable =>
      (_itemTotal + _convenienceFee - _discount).clamp(0, double.infinity);
  BookingModel? get latestBooking => _latestBooking;

  final List<Map<String, String>> dates = const [
    {'dayTag': 'TODAY', 'date': '12', 'weekday': 'Sat'},
    {'dayTag': 'TMRW', 'date': '13', 'weekday': 'Sun'},
    {'dayTag': 'NEXT', 'date': '14', 'weekday': 'Mon'},
    {'dayTag': 'WEEKDAY', 'date': '15', 'weekday': 'Tue'},
    {'dayTag': 'WEEKDAY', 'date': '16', 'weekday': 'Wed'},
  ];

  void setItemTotal(num total) {
    _itemTotal = total;
    _discount = (_itemTotal * 0.2).round();
    notifyListeners();
  }

  void selectDateIndex(int index) {
    if (_selectedDateIndex != index) {
      _selectedDateIndex = index;
      notifyListeners();
    }
  }

  void selectTimeSlot(String slot) {
    if (_selectedTimeSlot != slot) {
      _selectedTimeSlot = slot;
      notifyListeners();
    }
  }

  Future<bool> confirmBooking() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final selectedDate = dates[_selectedDateIndex];
      final dateStr = '${selectedDate['weekday']}, ${selectedDate['date']} Oct';

      final booking = await _repository.placeBooking({
        'id': 'HS-89421',
        'serviceTitle': 'Deep Home Cleaning (Standard)',
        'serviceSubtitle': 'Includes 2 Rooms • Duration ~2.5 hrs',
        'date': dateStr,
        'timeSlot': _selectedTimeSlot,
        'address': 'Flat 402, Tower B, Palm Springs, Sector 54, Gurgaon',
        'itemTotal': _itemTotal,
        'convenienceFee': _convenienceFee,
        'discount': _discount,
        'totalPayable': totalPayable,
        'promoCode': _appliedPromo,
      });

      _latestBooking = booking;
      _isLoading = false;
      notifyListeners();
      return true;
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Booking creation failed. Please retry.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
