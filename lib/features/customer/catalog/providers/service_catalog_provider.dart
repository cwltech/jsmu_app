import 'package:flutter/material.dart';
import 'package:jsmu/core/errors/failure.dart';

import '../models/service_item_model.dart';
import '../repositories/catalog_repository.dart';

class ServiceCatalogProvider extends ChangeNotifier {
  final CatalogRepository _repository;

  ServiceCatalogProvider({CatalogRepository? repository})
    : _repository = repository ?? CatalogRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<ServiceItemModel> _services = [];
  int _selectedTab = 0; // 0: Jet Clean, 1: Gas & Repair, 2: Installation

  // Cart Map: serviceId -> CartItemModel
  final Map<String, CartItemModel> _cart = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ServiceItemModel> get services => _services;
  int get selectedTab => _selectedTab;
  Map<String, CartItemModel> get cart => _cart;

  int get totalItemCount =>
      _cart.values.fold(0, (sum, item) => sum + item.quantity);
  num get totalCartPrice =>
      _cart.values.fold(0, (sum, item) => sum + item.totalPrice);
  num get totalSavings =>
      _cart.values.fold(0, (sum, item) => sum + item.totalSavings);

  int getQuantity(String serviceId) {
    return _cart[serviceId]?.quantity ?? 0;
  }

  void setSelectedTab(int index) {
    if (_selectedTab != index) {
      _selectedTab = index;
      notifyListeners();
    }
  }

  void addToCart(ServiceItemModel service) {
    if (_cart.containsKey(service.id)) {
      _cart[service.id]!.quantity += 1;
    } else {
      _cart[service.id] = CartItemModel(service: service, quantity: 1);
    }
    notifyListeners();
  }

  void incrementQuantity(String serviceId) {
    if (_cart.containsKey(serviceId)) {
      _cart[serviceId]!.quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String serviceId) {
    if (_cart.containsKey(serviceId)) {
      if (_cart[serviceId]!.quantity > 1) {
        _cart[serviceId]!.quantity -= 1;
      } else {
        _cart.remove(serviceId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<void> fetchServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _repository.getAcServices();
      // Pre-add the first item if cart is empty, exactly matching the Figma initial state!
      if (_cart.isEmpty && _services.isNotEmpty) {
        _cart[_services.first.id] = CartItemModel(
          service: _services.first,
          quantity: 1,
        );
      }
      _isLoading = false;
      notifyListeners();
    } on Failure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load services';
      _isLoading = false;
      notifyListeners();
    }
  }
}
