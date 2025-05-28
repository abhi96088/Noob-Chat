import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void init(){
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      _showNotification(message);
    });
  }

  void _showNotification(RemoteMessage message) async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('high_importance_channel', 'High Importance Notifications', importance: Importance.max, priority: Priority.high);

      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(0, message.notification?.title ?? '', message.notification?.body ?? '', platformChannelSpecifics);
  }
}