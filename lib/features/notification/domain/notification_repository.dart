import 'package:lingo_sign/features/notification/domain/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getallNotification();
  Future<void> markAsRead(String notifId);
  Future<void> sendFriendRequest(String toUserId);
  Future<void> sendAcceptNotification({
    required String requestNotifId,
    required String senderId,
  });
  Future<void> ignoreNotification({required String requestNotifId});
}
