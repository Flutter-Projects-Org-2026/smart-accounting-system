import 'package:flutter/material.dart';
import 'dart:async';
import '../models/service_model.dart';
import '../services/service_service.dart';

class ServiceProvider extends ChangeNotifier {
  final ServiceDataService _service = ServiceDataService();
  StreamSubscription? _subscription;

  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'الكل';

  List<ServiceModel> get services {
    var list = _services;
    if (_selectedCategory != 'الكل') {
      list = list.where((s) => s.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  int get totalServices => _services.length;
  int get activeServices => _services.where((s) => s.isActive).length;

  void listenToServices(String userId) {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _service.getServices(userId).listen((data) {
      _services = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addService({
    required String userId,
    required String name,
    required String description,
    required double price,
    required String category,
  }) async {
    await _service.addService(
      userId: userId,
      name: name,
      description: description,
      price: price,
      category: category,
    );
  }

  Future<void> updateService(ServiceModel service) =>
      _service.updateService(service);

  Future<void> deleteService(String id) => _service.deleteService(id);

  Future<void> toggleActive(String id, bool isActive) =>
      _service.toggleActive(id, isActive);

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}