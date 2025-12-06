import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// Initialize notification plugin
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);

    // Request notification permission for Android 13+
    if (Platform.isAndroid && (await _androidIsTiramisuOrHigher())) {
      PermissionStatus status = await Permission.notification.request();
      if (!status.isGranted) {
        print("Notification permission denied");
      }
    }
  }

  /// Show a notification
  static Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Helper to check if Android 13+ (API 33+)
  static Future<bool> _androidIsTiramisuOrHigher() async {
    if (!Platform.isAndroid) return false;
    try {
      final sdkInt = (await MethodChannel('flutter/platform').invokeMethod<int>('getSdkInt')) ?? 0;
      return sdkInt >= 33;
    } catch (e) {
      return false;
    }
  }
}
