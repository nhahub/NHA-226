import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/home/data/home_repository_impl.dart';
import 'package:lingo_sign/features/home/data/model/friend_model.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final homeRepo = HomeRepositoryImpl();
  final SharedPreferences prefs;
  static const key = 'recent_friends';

  SearchRepository(this.prefs);

  Future<List<Friend>> search(String query) async {
    final uid = firebaseAuth.currentUser!.uid;
    final q = query.toLowerCase();

    try {
      final friendsSnap = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('friends')
          .get();

      final friendModels = friendsSnap.docs
          .where((doc) => doc.id != '_init')
          .map((doc) => FriendModel.fromJson(doc.data()))
          .toList();

      final results = await Future.wait(
        friendModels.map((model) async {
          final user = await homeRepo.getUserInfoById(model.uid);

          if (user.name.toLowerCase().contains(q)) {
            return model.toFriend(
              name: user.name,
              email: user.email,
              imageUrl: user.imageUrl,
              lastSeen: user.lastSeen,
            );
          }
          return null;
        }),
      );

      return results.whereType<Friend>().toList();
    } catch (e) {
      throw Exception("Friend search failed: $e");
    }
  }

  Future<void> saveFriend(Friend friend) async {
    final recent = await getRecentModels();

    recent.removeWhere((m) => m.uid == friend.uid);

    recent.insert(0, FriendModel.fromFriend(friend));

    final jsonList = recent.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  Future<List<Friend>> getRecent() async {
    final models = await getRecentModels();

    final results = await Future.wait(
      models.map((model) async {
        final user = await homeRepo.getUserInfoById(model.uid);
        return model.toFriend(
          name: user.name,
          email: user.email,
          imageUrl: user.imageUrl,
          lastSeen: user.lastSeen,
        );
      }),
    );

    return results;
  }

  Future<List<FriendModel>> getRecentModels() async {
    final data = prefs.getStringList(key);
    if (data == null) return [];

    return data
        .map((e) => FriendModel.fromJson(jsonDecode(e)))
        .toList();
  }
}

