enum NotificationType { request, accepted, rejected, missedCall }

class AppNotification {
  final String title;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String id;
  final String fromUserId;

  AppNotification({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.isRead,
    required this.fromUserId,
  });
}
