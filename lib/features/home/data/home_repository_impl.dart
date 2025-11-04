import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/home/data/model/friend_model.dart';
import 'package:lingo_sign/features/home/data/model/user_model.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:lingo_sign/features/home/domain/entities/last_call.dart';
import 'package:lingo_sign/features/home/domain/entities/request.dart';
import 'package:lingo_sign/features/home/domain/entities/user_app.dart';
import 'package:lingo_sign/features/home/domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<UserApp> getUserInfo() async {
    final uid = firebaseAuth.currentUser!.uid;
    try {
      final userRef = firebaseFirestore.collection('users').doc(uid);
      final userDoc = await userRef.get();
      final user = UserModel.fromJson(userDoc.data()!).toUserApp();
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Friend>> getFriends() async {
    final uid = firebaseAuth.currentUser!.uid;

    try {
      final friendsRef = firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('friends');

      final friendsDoc = await friendsRef.get();

      if (friendsDoc.docs.isEmpty) {
        await friendsRef.doc('_init').set({
          'createdAt': FieldValue.serverTimestamp(),
        });
        return [];
      }

      final validDocs = friendsDoc.docs.where((doc) => doc.id != '_init');

      final freinds = validDocs
          .map((doc) => FriendModel.fromJson(doc.data()).toFriend())
          .toList();

      return freinds;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Friend>> getFavourites() async {
    return [];
  }

  @override
  Future<List<LastCall>> getLastCalls() async {
    return [];
  }

  @override
  Future<List<Request>> getRequstes() async {
    return [];
  }
}
