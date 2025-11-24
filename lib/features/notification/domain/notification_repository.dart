import 'package:lingo_sign/features/notification/domain/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getallNotification();
  Future<void> markAsRead(String notifId);
}
