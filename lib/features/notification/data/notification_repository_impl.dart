import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/notification/data/notification_model.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';
import 'package:lingo_sign/features/notification/domain/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<List<AppNotification>> getallNotificationStream() {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          final validDocs = snapshot.docs.where((doc) => doc.id != "_init");
          return validDocs
              .map((doc) {
                try {
                  return NotificationModel.fromFirestore(
                    doc,
                  ).toAppNotification();
                } catch (e) {
                  print('Error parsing notification: $e');
                  return null;
                }
              })
              .whereType<AppNotification>()
              .toList();
        });
  }

  @override
  Future<List<AppNotification>> getallNotification() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final snapshot = await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .orderBy('created_at', descending: true)
          .get();

      final validDocs = snapshot.docs.where((doc) => doc.id != "_init");
      final notifications = validDocs
          .map((doc) {
            try {
              return NotificationModel.fromFirestore(doc).toAppNotification();
            } catch (e) {
              print('Error parsing notification: $e');
              return null;
            }
          })
          .whereType<AppNotification>()
          .toList();

      return notifications;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching notifications: $e');
      rethrow;
    }
  }

  @override
  void listenToNotificationsRealTime(Function(List<AppNotification>) onUpdate) {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }

    try {
      firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .orderBy('created_at', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              try {
                final validDocs = snapshot.docs.where(
                  (doc) => doc.id != "_init",
                );
                final notifications = validDocs
                    .map((doc) {
                      try {
                        return NotificationModel.fromFirestore(
                          doc,
                        ).toAppNotification();
                      } catch (e) {
                        print('Error parsing notification: $e');
                        return null;
                      }
                    })
                    .whereType<AppNotification>()
                    .toList();
                onUpdate(notifications);
              } catch (e) {
                print('Error in snapshot processing: $e');
              }
            },
            onError: (error) {
              print('Error listening to notifications: $error');
            },
          );
    } catch (e) {
      print('Error setting up listener: $e');
    }
  }

  @override
  Future<void> markAsRead(String notifId) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
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
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final currentUserDoc = await firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final currentUserName = currentUserDoc.data()?['name'] ?? 'Someone';

    final batch = firebaseFirestore.batch();

    // Add both users as friends
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
      'uid': senderId,
      'is_favourite': false,
      'created_at': Timestamp.now(),
    });
    batch.set(senderFriendRef, {
      'uid': currentUser.uid,
      'is_favourite': false,
      'created_at': Timestamp.now(),
    });

    final requestsRef = await firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('requests')
        .where('uid', isEqualTo: senderId)
        .get();

    if (requestsRef.docs.isNotEmpty) {
      batch.delete(requestsRef.docs.first.reference);
    }

    // Update the notification to accepted
    final myNotifRef = firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .doc(requestNotifId);
    batch.update(myNotifRef, {'type': 'accepted', 'is_read': true});

    // Send accept notification to sender
    final acceptNotifRef = firebaseFirestore
        .collection('users')
        .doc(senderId)
        .collection('notifications')
        .doc();
    batch.set(acceptNotifRef, {
      'title': '$currentUserName accepted your request',
      'type': 'accepted',
      'from_user_id': currentUser.uid,
      'from_user_name': currentUserName,
      'created_at': Timestamp.now(),
      'is_read': false,
      'is_ignored': false,
    });

    await batch.commit();
  }

  @override
  Future<void> ignoreNotification({required String requestNotifId}) async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final notifRef = firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .doc(requestNotifId);

    await notifRef.update({'is_ignored': true});
  }

  @override
  Future<void> undoIgnoreNotification({required String requestNotifId}) async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final notifRef = firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .doc(requestNotifId);

    await notifRef.update({'is_ignored': false});
  }

  @override
  Future<void> sendFriendRequest(String toUserId) async {
    throw UnimplementedError();
  }
}
