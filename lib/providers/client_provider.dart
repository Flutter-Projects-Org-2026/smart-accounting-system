import 'package:flutter/material.dart';
import 'dart:async';
import '../models/client_model.dart';
import '../models/transaction_model.dart';
import '../services/client_service.dart';

class ClientProvider extends ChangeNotifier {
  final ClientService _service = ClientService();
  StreamSubscription? _clientsSub;
  StreamSubscription? _txSub;

  List<ClientModel> _clients = [];
  List<TransactionModel> _currentTransactions = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<ClientModel> get clients {
    if (_searchQuery.isEmpty) return _clients;
    return _clients
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<TransactionModel> get currentTransactions => _currentTransactions;
  bool get isLoading => _isLoading;

  double get totalLahu => _clients.where((c) => c.balance > 0).fold(0, (s, c) => s + c.balance);
  double get totalAlayhi => _clients.where((c) => c.balance < 0).fold(0, (s, c) => s + c.balance.abs());

  void listenToClients(String userId) {
    _isLoading = true;
    notifyListeners();
    _clientsSub?.cancel();
    _clientsSub = _service.getClients(userId).listen((data) {
      _clients = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  void listenToTransactions(String clientId) {
    _txSub?.cancel();
    _txSub = _service.getTransactions(clientId).listen((data) {
      _currentTransactions = data;
      notifyListeners();
    });
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  Future<String> addClient({
    required String userId,
    required String name,
    required String phone,
    String notes = '',
  }) => _service.addClient(userId: userId, name: name, phone: phone, notes: notes);

  Future<void> updateClient(ClientModel client) => _service.updateClient(client);

  Future<void> deleteClient(String id) => _service.deleteClient(id);

  Future<void> addTransaction({
    required String userId,
    required String clientId,
    required double amount,
    required String currency,
    required TransactionType type,
    String details = '',
    required DateTime date,
  }) => _service.addTransaction(
        userId: userId,
        clientId: clientId,
        amount: amount,
        currency: currency,
        type: type,
        details: details,
        date: date,
      );

  Future<void> deleteTransaction(TransactionModel tx) => _service.deleteTransaction(tx);

  ClientModel? getClientById(String id) {
    try {
      return _clients.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _clientsSub?.cancel();
    _txSub?.cancel();
    super.dispose();
  }
}