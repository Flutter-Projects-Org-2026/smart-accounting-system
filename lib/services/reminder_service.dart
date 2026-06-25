import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/reminder_model.dart';
import '../core/constants/app_constants.dart';

class ReminderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  CollectionReference get _collection => _db.collection(AppConstants.remindersCollection);

  Stream<List<ReminderModel>> getReminders(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((s) => s.docs.map((d) => ReminderModel.fromMap(d.data() as Map<String, dynamic>)).toList());
  }

  Future<String> addReminder({
    required String userId,
    required String name,
    required DateTime dateTime,
    String note = '',
  }) async {
    final id = _uuid.v4();
    final reminder = ReminderModel(
      id: id,
      userId: userId,
      name: name,
      dateTime: dateTime,
      note: note,
      createdAt: DateTime.now(),
    );
    await _collection.doc(id).set(reminder.toMap());
    return id;
  }

  Future<void> deleteReminder(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> toggleDone(String id, bool isDone) async {
    await _collection.doc(id).update({'isDone': isDone});
  }
}