import 'package:d_reader_flutter/core/providers/fcm/notification_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notification_controller.g.dart';

@riverpod
class NotificationController extends _$NotificationController {
  @override
  FutureOr<void> build() {}

  Future<void> init() async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.requestNotificationPermission();
    final fcmToken = await notificationService.getFCMToken();
    final user = ref.read(environmentNotifierProvider).user;
    if (fcmToken != null &&
        user != null &&
        !user.deviceTokens.contains(fcmToken)) {
      await ref.read(userRepositoryProvider).insertFcmToken(fcmToken);
    }
    await notificationService.subscribeToTopic('broadcast');
    await notificationService.initNotificationsHandler();
    await Future.wait(
      [
        notificationService.initForegroundNotificationsHandler(),
        notificationService.initBackgroundNotificationsActionHandler(),
        notificationService.initTerminatedNotificationsActionHandler()
      ],
    );
  }
}
