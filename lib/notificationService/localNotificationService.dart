import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static const String serverKey =
      'AAAAQxrXFV0:APA91bHNYQJFb_QiXnBU-S6ENbH3I0iRqxDI1iYJrqDb8jJ72BKCYOOCXS3_4cSAelcn4D5RHcae0HIJ2Q30ywXz2ETY9HBjtANNVqVGLnbKaFdS6eM5eRkT3RBQ9-dZD-JnLbB7_d54';
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<String> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    print('Device Token = ${token.toString()}');
    return token.toString();
  }

  static Future<void> initialize() async {
    print('##################');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      print('Router Value = ${notificationResponse.id}');
    });
  }

  static Future<void> _showNotification() async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('chatmate', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.show(
        id, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  static void createAndDisplayNotificationChannel(
      RemoteMessage remoteMessage) async {
    try {
      print('Displaying Notification through channel');
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("chatmate", "chatmate",
              importance: Importance.max,
              priority: Priority.high,
              visibility: NotificationVisibility.public));
      print('Before showing');
      await notificationsPlugin.show(
        id,
        remoteMessage.notification!.title,
        remoteMessage.notification!.body,
        notificationDetails,
      );
      print('Channel no Errors');
    } catch (e) {
      print('Error in displaying notification channel = $e');
    }
  }

  static sendMessageNotification(
      String title, String message, String fcmToken, String image) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': message
    };

    try {
      http.Response response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{
              'body': message,
              'title': title,
              'image': image,
              "channel_id": "chatmate",
              'sound': 'default'
            },
            'priority': 'high',
            'data': data,
            'to': '$fcmToken'
          }));
      print('Response = ${response.body}');
      if (response.statusCode == 200) {
        _showNotification();
        print('Notification sent');
      } else {
        print('Notification NOT sent and status = ${response.statusCode}');
      }
    } catch (e) {
      print("Error while sending notification = $e");
    }
  }
}
