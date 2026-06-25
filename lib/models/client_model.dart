class ClientModel {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String notes;
  final double balance; // موجب = له عندك، سالب = عليه لك
  final DateTime createdAt;

  ClientModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.notes = '',
    this.balance = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'name': name,
    'phone': phone,
    'notes': notes,
    'balance': balance,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ClientModel.fromMap(Map<String, dynamic> map) => ClientModel(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',
    name: map['name'] ?? '',
    phone: map['phone'] ?? '',
    notes: map['notes'] ?? '',
    balance: (map['balance'] ?? 0).toDouble(),
    createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
  );

  ClientModel copyWith({String? name, String? phone, String? notes, double? balance}) =>
      ClientModel(
        id: id,
        userId: userId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        notes: notes ?? this.notes,
        balance: balance ?? this.balance,
        createdAt: createdAt,
      );
}