import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';

class NotificationModel {
  final String id;
  final String title;
  final String type;
  final DateTime createdAt;
  final bool isRead;
  final String fromUserId;
  final bool isIgnored; // ← أضفنا

  NotificationModel({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.isRead,
    required this.fromUserId,
    this.isIgnored = false,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      createdAt: (data['created_at'] is Timestamp)
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.parse(data['created_at']),
      isRead: data['is_read'] ?? false,
      fromUserId: data['from_user_id'] ?? '',
      isIgnored: data['is_ignored'] ?? false, // ← جلب من Firestore
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'created_at': createdAt,
      'is_read': isRead,
      'is_ignored': isIgnored, // ← حفظ في Firestore
    };
  }

  AppNotification toAppNotification() {
    return AppNotification(
      id: id,
      title: title,
      type: _mapType(type),
      createdAt: createdAt,
      isRead: isRead,
      fromUserId: fromUserId,
      isIgnored: isIgnored,
    );
  }
}

NotificationType _mapType(String type) {
  switch (type) {
    case 'request':
      return NotificationType.request;
    case 'accepted':
      return NotificationType.accepted;
    case 'rejected':
      return NotificationType.rejected;
    case 'missedCall':
      return NotificationType.missedCall;
    default:
      return NotificationType.request;
  }
}
