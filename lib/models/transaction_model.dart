enum TransactionType { lahu, alayhi } // له / عليه

class TransactionModel {
  final String id;
  final String userId;
  final String clientId;
  final double amount;
  final String currency; // محلي / دولار / سعودي
  final TransactionType type;
  final String details;
  final DateTime date;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.clientId,
    required this.amount,
    required this.currency,
    required this.type,
    this.details = '',
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'clientId': clientId,
    'amount': amount,
    'currency': currency,
    'type': type == TransactionType.lahu ? 'lahu' : 'alayhi',
    'details': details,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',
    clientId: map['clientId'] ?? '',
    amount: (map['amount'] ?? 0).toDouble(),
    currency: map['currency'] ?? 'محلي',
    type: map['type'] == 'lahu' ? TransactionType.lahu : TransactionType.alayhi,
    details: map['details'] ?? '',
    date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
  );
}