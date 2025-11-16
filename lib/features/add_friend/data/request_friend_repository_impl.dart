import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/add_friend/data/request_model.dart';
import 'package:lingo_sign/features/add_friend/domain/request_friend_repository.dart';

class RequestFriendRepositoryImpl implements RequestFriendRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> sendFriendRequest(String email) async {
    final currentUser = auth.currentUser;

    if (currentUser == null) throw Exception('user not logged in');

    final friend = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (friend.docs.isEmpty) throw Exception('user not found');

    final friendId = friend.docs.first.id;

    final exist = await firestore
        .collection('users')
        .doc(friendId)
        .collection('requests')
        .where('uid', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'pending')
        .get();

    if (exist.docs.isNotEmpty) throw Exception("Request already sent");

    final friendExist = await firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('requests')
        .doc(friendId)
        .get();

    if (friendExist.exists) throw Exception("User is in your friends");

    final request = RequestModel(
      uid: currentUser.uid,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    await firestore
        .collection('users')
        .doc(friendId)
        .collection('requests')
        .add(request.toMap());

    await firestore
        .collection('users')
        .doc(friendId)
        .collection('notifications')
        .doc()
        .set({
          'title': '${currentUser.displayName} want to be your friend',
          'type': 'request',
          'is_read': false,
          'created_at': DateTime.now(),
        });
  }
}
