
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/add_friend/data/models/request_model.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class RequestFriendRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  RequestFriendRepository({required this.firestore, required this.auth});

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
        .collection('friend_requests')
        .where('fromId', isEqualTo: currentUser.uid)
        .where('toId', isEqualTo: friendId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (exist.docs.isNotEmpty) throw Exception("Request already sent");

    final request = Request(
      fromId: currentUser.uid,
      toId: friendId,
      status: 'pending',
      time: DateTime.now(),
    );

    await firestore.collection('requests').add(request.toMap());
  }
}
