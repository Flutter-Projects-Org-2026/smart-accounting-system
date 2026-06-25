import 'package:flutter/material.dart';
import 'dart:async';
import '../models/reminder_model.dart';
import '../services/reminder_service.dart';
import '../services/notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  final ReminderService _service = ReminderService();
  final NotificationService _notificationService = NotificationService();
  StreamSubscription? _sub;

  List<ReminderModel> _reminders = [];
  bool _isLoading = false;

  List<ReminderModel> get reminders => _reminders;
  bool get isLoading => _isLoading;

  void listenToReminders(String userId) {
    _isLoading = true;
    notifyListeners();
    _sub?.cancel();
    _sub = _service.getReminders(userId).listen((data) {
      _reminders = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addReminder({
    required String userId,
    required String name,
    required DateTime dateTime,
    String note = '',
  }) async {
    final id = await _service.addReminder(
      userId: userId,
      name: name,
      dateTime: dateTime,
      note: note,
    );
    await _notificationService.scheduleReminder(
      id: id,
      title: name,
      body: note.isNotEmpty ? note : 'حان موعد التنبيه',
      dateTime: dateTime,
    );
  }

  Future<void> deleteReminder(String id) async {
    await _notificationService.cancelReminder(id);
    await _service.deleteReminder(id);
  }

  Future<void> toggleDone(String id, bool isDone) =>
      _service.toggleDone(id, isDone);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}