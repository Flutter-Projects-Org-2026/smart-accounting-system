class ReminderModel {
  final String id;
  final String userId;
  final String name;
  final DateTime dateTime;
  final String note;
  final bool isDone;
  final DateTime createdAt;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.dateTime,
    this.note = '',
    this.isDone = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'name': name,
    'dateTime': dateTime.toIso8601String(),
    'note': note,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ReminderModel.fromMap(Map<String, dynamic> map) => ReminderModel(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',
    name: map['name'] ?? '',
    dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
    note: map['note'] ?? '',
    isDone: map['isDone'] ?? false,
    createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
  );
}