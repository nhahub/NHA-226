import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/friend_account/Freind.dart';

class FriendDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FriendDataSource(this.firestore, this.auth);

  Stream<Friend> getFriendByUid(String uid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('friends')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data()!;
      return Friend(
        uid: uid,
        name: data["name"],
        imageUrl: data["imageUrl"],
        lastSeen: data["lastSeen"],
        isFavourite: data["is_Favourite"],
      );
    });
  }

  Future<void> updateFavourite(String uid, bool value) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('friends')
        .doc(uid)
        .update({"is_Favourite": value});
  }

  Future<void> deleteFriend(String uid) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('friends')
        .doc(uid)
        .delete();
  }
}
