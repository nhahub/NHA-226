import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';

class NotificationModel {
  final String title;
  final NotificationType notificationType;
  final DateTime date;
  final bool isSeen;

  NotificationModel({
    required this.title,
    required this.notificationType,
    required this.date,
    required this.isSeen,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      notificationType: NotificationType.values.firstWhere(
        (e) => e.name == json['notificationType'],
        orElse: () => NotificationType.request,
      ),
      date: (json['date'] is Timestamp)
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date']),
      isSeen: json['isSeen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'notificationType': notificationType.name,
      'date': date.toIso8601String(),
      'isSeen': isSeen,
    };
  }

  AppNotification toAppNotification() {
    return AppNotification(
      title: title,
      notificationType: notificationType,
      date: date,
      isSeen: isSeen,
    );
  }
}
