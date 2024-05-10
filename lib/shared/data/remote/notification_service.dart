import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/url_utils.dart';
import 'package:d_reader_flutter/features/comic/presentation/screens/comic_details.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/screens/comic_issue_details.dart';
import 'package:d_reader_flutter/features/creator/presentation/screens/creator_details.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/screens/digital_asset_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

handleNotificationAction(Map payload) {
  if (payload.containsKey(NotificationDataKey.comicIssueId.stringValue)) {
    return routerNavigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => ComicIssueDetails(
          id: payload[NotificationDataKey.comicIssueId.stringValue],
        ),
      ),
    );
  } else if (payload.containsKey(NotificationDataKey.comicSlug.stringValue)) {
    return routerNavigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => ComicDetails(
          slug: payload[NotificationDataKey.comicSlug.stringValue],
        ),
      ),
    );
  } else if (payload.containsKey(NotificationDataKey.creatorSlug.stringValue)) {
    return routerNavigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => CreatorDetailsView(
          slug: payload[NotificationDataKey.creatorSlug.stringValue],
        ),
      ),
    );
  } else if (payload
      .containsKey(NotificationDataKey.digitalAssetAddress.stringValue)) {
    return routerNavigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => DigitalAssetDetails(
          address: payload[NotificationDataKey.digitalAssetAddress.stringValue],
        ),
      ),
    );
  } else if (payload.containsKey(NotificationDataKey.externalUrl.stringValue)) {
    return openUrl(
      payload[NotificationDataKey.externalUrl.stringValue],
      LaunchMode.externalApplication,
    );
  }
}

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  bool isNotificationsHandlerInitialized = false;

  late final AndroidNotificationChannel channel;
  final FlutterLocalNotificationsPlugin local =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    try {
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }

  // Inits handler that will displays notifications
  Future<void> initNotificationsHandler() async {
    if (isNotificationsHandlerInitialized) return;

    const initializationSetting = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/notification_icon'),
      iOS: DarwinInitializationSettings(),
    );

    await local.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (notification) {
      if (notification.payload != null) {
        Map payload = jsonDecode(notification.payload!);
        handleNotificationAction(payload);
      }
    });

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // This needs to match value defined in AndroidManifest.xml
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high,
      enableLights: true,
    );

    // Creates an Android Notification Channel
    // We use this channel in the `AndroidManifest.xml` file to override the
    // default FCM channel to enable foreground notifications.
    await local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow foreground notifications
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isNotificationsHandlerInitialized = true;
  }

  // Inits handler that will display notifications when app is in foreground
  Future<void> initForegroundNotificationsHandler() async {
    FirebaseMessaging.onMessage
        .listen((message) => displayNotification(message));
  }

  // If app is opened from background state when user clicks on notification
  // Allow to handle notification data eg: navigate to a specific screen
  Future<void> initBackgroundNotificationsActionHandler() async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleNotificationAction(message.data);
    });
  }

  // If app is opened from terminated state when user clicks on notification
  // Allow to handle notification data eg: navigate to a specific screen
  Future<void> initTerminatedNotificationsActionHandler() async {
    RemoteMessage? lastMessage = await messaging.getInitialMessage();

    if (lastMessage != null) {
      handleNotificationAction(lastMessage.data);
    }
  }

  // Presents the notification to the user
  void displayNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      local.show(
        notification.hashCode,
        notification.title,
        notification.body,
        payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              priority: Priority.high,
              color: ColorPalette.notificationBgColor,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            )),
      );
    }
  }

  // Gets Device's FCM token, this is used to target a specific device
  // Store this token along / linked with user / account info in DB
  // Can be also useful to store it in local storage to quickly check if new emitted token differs from stored token.
  // If so, update new token in DB
  Future<String?> getFCMToken() async {
    final token = await messaging.getToken();
    return token;
  }

  // Listens for FCMToken update, if so check with stored token and update in local storage / DB if necessary
  // Not necessary needed if getFCMToken is checked at every launch
  Future<void> onTokenRefresh() async {
    messaging.onTokenRefresh.listen((token) {
      // For demo purposes
      debugPrint('FCM Token Is: $token');
    });
  }

  // Subscribes the device to given topic eg: news | drop | and so on
  // Can be used to subscribe a user to topics by default
  // Can be used on settings screen where user choose which notifications to subscribe
  Future<void> subscribeToTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
  }

  // Unsubscribes the device from given topic
  // Can be used on settings screen where user choose which notifications to unsubscribe
  Future<void> unsubscribeFromTopic(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
  }
}
