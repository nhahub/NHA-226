enum NotificationType { missedCall, request }

class AppNotification {
  final String title;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.title,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });
}
