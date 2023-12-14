// notification_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'simple_notification.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  List<SimpleNotification> _messages = [];
  List<SimpleNotification> get messages => _messages;

  Future<void> loadNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? messagesJson = prefs.getString('notifications');
    if (messagesJson != null) {
      final List<dynamic> jsonList = json.decode(messagesJson) as List<dynamic>;
      _messages = jsonList
          .map((messageJson) => SimpleNotification.fromMap(messageJson as Map<String, dynamic>))
          .toList();
    }
  }

  void addMessage(SimpleNotification message) async {
    _messages.insert(0, message);
    await _saveNotifications();
  }

  void deleteMessage(int index) async {
    _messages.removeAt(index);
    await _saveNotifications();
  }

  Future<void> _saveNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String messagesJson = json.encode(_messages.map((message) => message.toMap()).toList());
    await prefs.setString('notifications', messagesJson);
  }
}

// simple_notification.dart
class SimpleNotification {
  String? title;
  String? body;

  SimpleNotification({this.title, this.body});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

  factory SimpleNotification.fromMap(Map<String, dynamic> map) {
    return SimpleNotification(
      title: map['title'],
      body: map['body'],
    );
  }
}
