import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { request, accepted, rejected, missedCall, general }

class AppNotification {
  final String id;
  final String title;
  final String fromUserId;
  final String toUserId;
  final DateTime createdAt;
  final NotificationType type;
  final bool isRead;
  final bool isIgnored;

  AppNotification({
    required this.id,
    required this.title,
    required this.fromUserId,
    required this.toUserId,
    required this.createdAt,
    required this.type,
    required this.isRead,
    required this.isIgnored,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json, String docId) {
    return AppNotification(
      id: docId,
      title: json["title"] ?? "",
      fromUserId: json["fromUserId"] ?? "",
      toUserId: json["toUserId"] ?? "",
      createdAt: (json["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: _mapType(json["type"]),
      isRead: json["isRead"] ?? false,
      isIgnored: json["ignored"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "fromUserId": fromUserId,
      "toUserId": toUserId,
      "createdAt": createdAt,
      "type": type.name,
      "isRead": isRead,
      "ignored": isIgnored,
    };
  }

  static NotificationType _mapType(String? value) {
    switch (value) {
      case "request":
        return NotificationType.request;
      case "accepted":
        return NotificationType.accepted;
      case "rejected":
        return NotificationType.rejected;
      case "missedCall":
        return NotificationType.missedCall;
      default:
        return NotificationType.general;
    }
  }
}
