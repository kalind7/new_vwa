import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../config/app_config.dart';
import 'fcm_background_handler.dart';
import 'notification_remote_data_source.dart';

class NotificationService {
  NotificationService({
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    NotificationRemoteDataSource? notificationRemote,
  }) : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin(),
       _notificationRemote = notificationRemote;

  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final NotificationRemoteDataSource? _notificationRemote;

  static bool _backgroundHandlerRegistered = false;

  Future<void> initialize() async {
    if (!_backgroundHandlerRegistered) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      _backgroundHandlerRegistered = true;
    }

    await _firebaseMessaging.requestPermission();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    _firebaseMessaging.onTokenRefresh.listen((token) {
      registerTokenWithBackend(token);
    });
  }

  Future<String?> getDeviceToken() {
    return _firebaseMessaging.getToken();
  }

  Future<void> registerTokenWithBackend(String token) async {
    if (!AppConfig.enableFirebaseNotifications) {
      return;
    }

    final remote = _notificationRemote;
    if (remote == null || token.isEmpty) {
      return;
    }

    final deviceType = Platform.isIOS ? 'ios' : 'android';
    final result = await remote.registerFcmToken(
      token: token,
      deviceType: deviceType,
    );

    result.fold(
      (failure) => debugPrint('FCM register failed: ${failure.message}'),
      (_) => debugPrint('FCM token registered'),
    );
  }

  Future<void> syncTokenWithBackend() async {
    final token = await getDeviceToken();
    if (token != null && token.isNotEmpty) {
      await registerTokenWithBackend(token);
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'vwa_general',
      'General Notifications',
      channelDescription: 'General app notifications for Vehicle Washing App.',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
    );
  }
}
