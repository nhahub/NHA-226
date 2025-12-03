import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';

class NotificationModel {
  final String id;
  final String title;
  final String type;
  final DateTime createdAt;
  final bool isRead;
  final String fromUserId;
  final String toUserId;
  final bool isIgnored;

  NotificationModel({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.isRead,
    required this.fromUserId,
    required this.toUserId,
    this.isIgnored = false,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime createdAtValue = DateTime.now();
    try {
      final createdAtData = data['created_at'];
      if (createdAtData is Timestamp) {
        createdAtValue = createdAtData.toDate();
      } else if (createdAtData is String) {
        createdAtValue = DateTime.parse(createdAtData);
      } else if (createdAtData is DateTime) {
        createdAtValue = createdAtData;
      }
    } catch (e) {
      print('Error parsing created_at: $e');
      createdAtValue = DateTime.now();
    }

    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      createdAt: createdAtValue,
      isRead: data['is_read'] ?? false,
      fromUserId: data['from_user_id'] ?? '',
      toUserId: data['to_user_id'] ?? '',
      isIgnored: data['is_ignored'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'created_at': Timestamp.fromDate(createdAt),
      'is_read': isRead,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'is_ignored': isIgnored,
    };
  }

  AppNotification toAppNotification() {
    return AppNotification(
      id: id,
      title: title,
      fromUserId: fromUserId,
      toUserId: toUserId,
      createdAt: createdAt,
      type: _mapType(type),
      isRead: isRead,
      isIgnored: isIgnored,
    );
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
        return NotificationType.general;
    }
  }
}
