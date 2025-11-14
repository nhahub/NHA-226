import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';

class NotificationModel {
  final String title;
  final NotificationType notificationType;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.notificationType,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      notificationType: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.request,
      ),
      createdAt: (json['date'] is Timestamp)
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date']),
      isRead: json['isSeen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': notificationType.name,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  AppNotification toAppNotification() {
    return AppNotification(
      title: title,
      type: notificationType,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}
