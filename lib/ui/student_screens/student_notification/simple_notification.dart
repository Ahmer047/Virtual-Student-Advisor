// simple_notification.dart
import 'dart:convert';

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

  String toJson() => json.encode(toMap());

  factory SimpleNotification.fromJson(String source) => SimpleNotification.fromMap(json.decode(source));
}
