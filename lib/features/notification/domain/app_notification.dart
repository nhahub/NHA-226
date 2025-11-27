enum NotificationType { request, accepted, rejected, missedCall }

class AppNotification {
  final String id;
  final String title;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String fromUserId;
  final bool isIgnored;
  AppNotification({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.isRead,
    required this.fromUserId,
    this.isIgnored = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? fromUserId,
    bool? isIgnored,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      fromUserId: fromUserId ?? this.fromUserId,
      isIgnored: isIgnored ?? this.isIgnored,
    );
  }
}
