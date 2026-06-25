class ServiceModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isActive;
  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id':          id,
    'userId':      userId,
    'name':        name,
    'description': description,
    'price':       price,
    'category':    category,
    'isActive':    isActive,
    'createdAt':   createdAt.toIso8601String(),
  };

  factory ServiceModel.fromMap(Map<String, dynamic> map) => ServiceModel(
    id:          map['id'] ?? '',
    userId:      map['userId'] ?? '',
    name:        map['name'] ?? '',
    description: map['description'] ?? '',
    price:       (map['price'] ?? 0).toDouble(),
    category:    map['category'] ?? 'أخرى',
    isActive:    map['isActive'] ?? true,
    createdAt:   DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
  );

  ServiceModel copyWith({
    String? name,
    String? description,
    double? price,
    String? category,
    bool? isActive,
  }) => ServiceModel(
    id: id,
    userId: userId,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    category: category ?? this.category,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt,
  );
}