import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/notification/data/notification_model.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';
import 'package:lingo_sign/features/notification/domain/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<List<AppNotification>> getallNotification() async {
    final user = firebaseAuth.currentUser!;

    try {
      final notificationRef = firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications');

      final notificationSnapshot = await notificationRef.get();

      final validDocs = notificationSnapshot.docs.where(
        (doc) => doc.id != "_init",
      );

      List<AppNotification> notifications = validDocs
          .map(
            (doc) => NotificationModel.fromFirestore(doc).toAppNotification(),
          )
          .toList();

      return notifications;
    } catch (e) {
      throw Exception("Error loading notifications: $e");
    }
  }

  @override
  Future<void> markAsRead(String notifId) async {
    final user = firebaseAuth.currentUser!;

    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notifId)
          .update({'is_read': true});
    } catch (e) {
      throw Exception("Failed to mark notification as read: $e");
    }
  }
}
