class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String companyName;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.companyName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id':          id,
    'name':        name,
    'email':       email,
    'phone':       phone,
    'companyName': companyName,
    'createdAt':   createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id:          map['id'] ?? '',
    name:        map['name'] ?? '',
    email:       map['email'] ?? '',
    phone:       map['phone'] ?? '',
    companyName: map['companyName'] ?? '',
    createdAt:   DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
  );
}