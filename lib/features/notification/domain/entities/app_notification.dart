enum NotificationType { missedCall, request }

class AppNotification {
  final String title;
  final NotificationType notificationType;
  final DateTime date;
  final bool isSeen;

  AppNotification({
    required this.title,
    required this.notificationType,
    required this.date,
    required this.isSeen,
  });
}
