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
          .collection('notification');

      final notificationDoc = await notificationRef.get();

      if (notificationDoc.docs.isEmpty) {
        await notificationRef.doc('_init').set({
          'createdAt': FieldValue.serverTimestamp(),
        });

        return [];
      }

      final validDocs = notificationDoc.docs.where((doc) => doc.id != '_init');

      List<AppNotification> notifications = validDocs
          .map(
            (doc) => NotificationModel.fromJson(doc.data()).toAppNotification(),
          )
          .toList();

      return notifications;
    } catch (e) {
      throw Exception(e);
    }
  }
}
