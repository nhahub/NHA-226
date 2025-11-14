import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';

class NotificationModel {
  final String title;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      createdAt: (json['created_at'] is Timestamp)
          ? (json['created_at'] as Timestamp).toDate()
          : DateTime.parse(json['created_at']),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'created_at': createdAt.toString(),
      'is_read': isRead,
    };
  }

  AppNotification toAppNotification() {
    return AppNotification(
      title: title,
      type: type == 'request'
          ? NotificationType.request
          : NotificationType.missedCall,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}
