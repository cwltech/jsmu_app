import 'package:flutter/material.dart';
import 'package:jsmu/core/errors/failure.dart';

import '../models/popular_service.dart';
import '../models/service_category.dart';
import '../repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repository;

  HomeProvider({HomeRepository? repository})
    : _repository = repository ?? HomeRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<ServiceCategory> _categories = [];
  List<PopularService> _popularServices = [];
  String _selectedLocation = 'Sector 54, Gurgaon';
  String _searchQuery = '';
  int _activeNavIndex = 0;
  String _selectedQuickFilter = 'Tap Repair';
  String _selectedBookedFilter = 'All Services';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ServiceCategory> get categories => _categories;
  List<PopularService> get popularServices => _searchQuery.isEmpty
      ? _popularServices
      : _popularServices
            .where(
              (s) =>
                  s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  s.category.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
  String get selectedLocation => _selectedLocation;
  String get searchQuery => _searchQuery;
  int get activeNavIndex => _activeNavIndex;
  String get selectedQuickFilter => _selectedQuickFilter;
  String get selectedBookedFilter => _selectedBookedFilter;

  void setSelectedQuickFilter(String filter) {
    if (_selectedQuickFilter != filter) {
      _selectedQuickFilter = filter;
      notifyListeners();
    }
  }

  void setSelectedBookedFilter(String filter) {
    if (_selectedBookedFilter != filter) {
      _selectedBookedFilter = filter;
      notifyListeners();
    }
  }

  void setActiveNavIndex(int index) {
    if (_activeNavIndex != index) {
      _activeNavIndex = index;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getPopularServices(),
      ]);

      _categories = results[0] as List<ServiceCategory>;
      _popularServices = results[1] as List<PopularService>;
      _isLoading = false;
      notifyListeners();
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load home data';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHomeData() async {
    await fetchHomeData();
  }
}
