import 'package:d_reader_flutter/shared/data/remote/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}

@Riverpod(keepAlive: true)
firebaseMessaging(FirebaseMessagingRef ref) {
  return FirebaseMessaging.instance;
}
