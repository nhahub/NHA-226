
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart' show FirebaseMessaging;
import 'package:lingo_sign/features/add_friend/data/models/request_model.dart';


class RequestFriendRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final messaging = FirebaseMessaging.instance;

  RequestFriendRepository();

  Future<void> sendFriendRequest(String email) async {
    final currentUser = auth.currentUser;

    if (currentUser == null) throw Exception('user not logged in');

    final friend = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (friend.docs.isEmpty) throw Exception('user not found');

    final friendId = friend.docs.first.id;
    final friendToken = friend.docs.first.data()['token'];

    final exist = await firestore
        .collection('requests')
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
