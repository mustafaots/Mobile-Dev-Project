import 'dart:convert';
import 'dart:io' show Platform;

import 'package:easy_vacation/services/api/api_service_locator.dart';
import 'package:easy_vacation/services/sharedprefs.services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();


  // Notification channels
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  /// Initialize notification service
  static Future<void> init() async {
    await _initLocalNotifications();
    await _requestPermissions();
    await _setupFCM();
    await _registerToken();
  }

  /// Initialize local notifications
  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
  }

  /// Request notification permissions
  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  /// Setup Firebase Cloud Messaging
  static Future<void> _setupFCM() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Handle terminated state messages
    FirebaseMessaging.instance.getInitialMessage().then(_handleTerminatedMessage);

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);
  }

  /// Handle foreground messages
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Handling foreground message: ${message.messageId}');

    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      await _showLocalNotification(
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
        payload: jsonEncode(data),
      );
    }
  }

  /// Handle background messages
  static void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('Handling background message: ${message.messageId}');
    // Navigate to appropriate screen based on message data
    _navigateBasedOnData(message.data);
  }

  /// Handle terminated state messages
  static void _handleTerminatedMessage(RemoteMessage? message) {
    if (message != null) {
      debugPrint('Handling terminated message: ${message.messageId}');
      _navigateBasedOnData(message.data);
    }
  }

  /// Handle token refresh
  static Future<void> _onTokenRefresh(String token) async {
    debugPrint('FCM Token refreshed: $token');
    await SharedPrefsService.setFCMToken(token);
    await _registerToken();
  }

  /// Show local notification
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Handle notification tap
  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _navigateBasedOnData(data);
    }
  }

  /// Navigate based on notification data
  static void _navigateBasedOnData(Map<String, dynamic> data) {
    final type = data['type'];

    // Handle different notification types
    switch (type) {
      case 'booking_confirmed':
        // Navigate to booking details
        break;
      case 'booking_reminder':
        // Navigate to booking details
        break;
      case 'review_request':
        // Navigate to add review screen
        break;
      case 'promotional':
        // Navigate to relevant screen
        break;
      default:
        debugPrint('Unknown notification type: $type');
    }
  }

  /// Register FCM token with backend
  static Future<void> _registerToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await SharedPrefsService.setFCMToken(token);

        final userId = SharedPrefsService.getUserId();
        if (userId != null) {
          final apiService = ApiServiceLocator.notificationService;
          await apiService.registerFCMToken(userId, token);
        }
      }
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
    }
  }

  /// Get current FCM token
  static Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  /// Send test notification (for development)
  static Future<void> sendTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      0,
      'Test Notification',
      'This is a test notification from Easy Vacation',
      details,
    );
  }
}