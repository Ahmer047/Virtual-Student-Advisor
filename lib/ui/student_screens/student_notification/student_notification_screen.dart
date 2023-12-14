// notification_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();
  late Future _loadingFuture;

  @override
  void initState() {
    super.initState();
    _configureFirebaseListeners();
    _getToken();
    _loadingFuture = _notificationService.loadNotifications();
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      SimpleNotification notification = SimpleNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationService.addMessage(notification);
      });
    });
  }

  void _getToken() async {
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
  }

  void _deleteMessage(int index) {
    setState(() {
      _notificationService.deleteMessage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Screen'),
      ),
      body: FutureBuilder(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _notificationService.messages.length,
                      itemBuilder: (context, index) {
                        SimpleNotification message = _notificationService.messages[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(message.title ?? 'No Title'),
                            subtitle: Text(message.body ?? 'No Body'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteMessage(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
