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
    final snapshot = await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .get();
    final validDocs = snapshot.docs.where((doc) => doc.id != "_init");
    return validDocs
        .map((doc) => NotificationModel.fromFirestore(doc).toAppNotification())
        .toList();
  }

  @override
  Future<void> markAsRead(String notifId) async {
    final user = firebaseAuth.currentUser!;
    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .doc(notifId)
        .update({'is_read': true});
  }

  @override
  Future<void> sendAcceptNotification({
    required String requestNotifId,
    required String senderId,
  }) async {
    final currentUser = firebaseAuth.currentUser!;
    final currentUserDoc = await firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final currentUserName = currentUserDoc.data()?['name'] ?? 'Someone';

    final batch = firebaseFirestore.batch();

    final myFriendRef = firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .doc(senderId);
    final senderFriendRef = firebaseFirestore
        .collection('users')
        .doc(senderId)
        .collection('friends')
        .doc(currentUser.uid);

    batch.set(myFriendRef, {
      'friendId': senderId,
      'created_at': DateTime.now(),
    });
    batch.set(senderFriendRef, {
      'friendId': currentUser.uid,
      'created_at': DateTime.now(),
    });

    final myNotifRef = firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .doc(requestNotifId);
    batch.update(myNotifRef, {
      'title': '$currentUserName accepted this request',
      'type': 'accepted',
      'is_read': true,
    });

    await batch.commit();
  }

  @override
  Future<void> ignoreNotification({required String requestNotifId}) async {
    final currentUser = firebaseAuth.currentUser!;
    final notifRef = firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .doc(requestNotifId);

    await notifRef.delete();
  }

  @override
  Future<void> sendFriendRequest(String toUserId) async {
    throw UnimplementedError();
  }
}
