import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/home/data/model/friend_model.dart';
import 'package:lingo_sign/features/home/data/model/last_call_model.dart';
import 'package:lingo_sign/features/home/data/model/request_model.dart';
import 'package:lingo_sign/features/home/data/model/user_model.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
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
  Future<UserApp> getUserInfoById(String id) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(id).get();
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
      final validDocs = friendsDoc.docs.where((doc) => doc.id != '_init');
      final friends = validDocs
          .map((doc) => FriendModel.fromJson(doc.data()))
          .toList();

      final friendsInfo = await Future.wait(
        friends.map((friend) async {
          UserApp userApp = await getUserInfoById(friend.uid);
          return friend.toFriend(
            name: userApp.name,
            email: userApp.email,
            imageUrl: userApp.imageUrl,
            lastSeen: userApp.lastSeen,
          );
        }),
      );

      return friendsInfo;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Friend>> getFavourites() async {
    return [];
  }

  @override
  Future<List<Friend>> getLastCalls() async {
    final uid = firebaseAuth.currentUser!.uid;
    try {
      final lastCallsRef = firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('last_calls');

      final lastCallsDoc = await lastCallsRef.get();
      final validDocs = lastCallsDoc.docs.where((doc) => doc.id != '_init');
      final lastCalls = validDocs
          .map((doc) => LastCallModel.fromJson(doc.data()))
          .toList();

      final lastCallsInfo = await Future.wait(
        lastCalls.map((lastCall) async {
          UserApp userApp = await getUserInfoById(lastCall.uid);
          return lastCall.toFriend(
            email: userApp.email,
            name: userApp.name,
            imageUrl: userApp.imageUrl,
            isFavourite: false,
          );
        }),
      );

      return lastCallsInfo;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Request>> getRequstes() async {
    final uid = firebaseAuth.currentUser!.uid;
    try {
      final requstesRef = firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('requests');

      final requstesDoc = await requstesRef.get();
      final validDocs = requstesDoc.docs.where((doc) => doc.id != '_init');
      final requstes = validDocs
          .map((doc) => RequestModel.fromJson(doc.data()))
          .toList();

      final requstesInfo = await Future.wait(
        requstes.map((requst) async {
          UserApp userApp = await getUserInfoById(requst.uid);
          return requst.toRequste(
            name: userApp.name,
            imageUrl: userApp.imageUrl,
          );
        }),
      );

      return requstesInfo;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> acceptFriendRequest(String friendId) async {
    final uid = firebaseAuth.currentUser!.uid;
    try {
      final batch = firebaseFirestore.batch();

      final userFriendRef = firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('friends')
          .doc(friendId);

      batch.set(userFriendRef, {
        'uid': friendId,
        'is_favourite': false,
        'created_at': Timestamp.now(),
      });

      final friendUserRef = firebaseFirestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(uid);

      batch.set(friendUserRef, {
        'uid': uid,
        'is_favourite': false,
        'created_at': Timestamp.now(),
      });

      final requestRef = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('requests')
          .where('uid', isEqualTo: friendId)
          .get();

      if (requestRef.docs.isNotEmpty) {
        batch.delete(requestRef.docs.first.reference);
      }

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> rejectFriendRequest(String friendId) async {
    final uid = firebaseAuth.currentUser!.uid;
    try {
      final requestRef = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('requests')
          .where('uid', isEqualTo: friendId)
          .get();

      if (requestRef.docs.isNotEmpty) {
        await requestRef.docs.first.reference.delete();
      }

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addToFavourite(String uid) {
    return updateFavourite(uid, true);
  }

  @override
  Future<void> removeFromFavourite(String uid) {
    return updateFavourite(uid, false);
  }

  @override
  Future<void> unfriend(String uid) {
    return deleteFriend(uid);
  }

  Future<void> updateFavourite(String uid, bool value) async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('friends')
        .doc(uid)
        .update({"is_favourite": value});
  }

  Future<void> deleteFriend(String uid) async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('friends')
        .doc(uid)
        .delete();
  }
}
