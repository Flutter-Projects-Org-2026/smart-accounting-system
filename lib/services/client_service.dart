import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/client_model.dart';
import '../models/transaction_model.dart';
import '../core/constants/app_constants.dart';

class ClientService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  CollectionReference get _clients => _db.collection(AppConstants.clientsCollection);
  CollectionReference get _transactions => _db.collection(AppConstants.transactionsCollection);

  Stream<List<ClientModel>> getClients(String userId) {
    return _clients
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => ClientModel.fromMap(d.data() as Map<String, dynamic>)).toList());
  }

  Future<String> addClient({
    required String userId,
    required String name,
    required String phone,
    String notes = '',
  }) async {
    final id = _uuid.v4();
    final client = ClientModel(
      id: id,
      userId: userId,
      name: name,
      phone: phone,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await _clients.doc(id).set(client.toMap());
    return id;
  }

  Future<void> updateClient(ClientModel client) async {
    await _clients.doc(client.id).update(client.toMap());
  }

  Future<void> deleteClient(String id) async {
    await _clients.doc(id).delete();
    final txs = await _transactions.where('clientId', isEqualTo: id).get();
    for (final doc in txs.docs) {
      await doc.reference.delete();
    }
  }

  // ← السندات (له/عليه)
  Stream<List<TransactionModel>> getTransactions(String clientId) {
    return _transactions
        .where('clientId', isEqualTo: clientId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => TransactionModel.fromMap(d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> addTransaction({
    required String userId,
    required String clientId,
    required double amount,
    required String currency,
    required TransactionType type,
    String details = '',
    required DateTime date,
  }) async {
    final id = _uuid.v4();
    final tx = TransactionModel(
      id: id,
      userId: userId,
      clientId: clientId,
      amount: amount,
      currency: currency,
      type: type,
      details: details,
      date: date,
      createdAt: DateTime.now(),
    );
    await _transactions.doc(id).set(tx.toMap());

    // تحديث رصيد العميل
    final delta = type == TransactionType.lahu ? amount : -amount;
    await _clients.doc(clientId).update({
      'balance': FieldValue.increment(delta),
    });
  }

  Future<void> deleteTransaction(TransactionModel tx) async {
    await _transactions.doc(tx.id).delete();
    final delta = tx.type == TransactionType.lahu ? -tx.amount : tx.amount;
    await _clients.doc(tx.clientId).update({
      'balance': FieldValue.increment(delta),
    });
  }
}