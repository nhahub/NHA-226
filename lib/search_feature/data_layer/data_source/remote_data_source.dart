import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/search_feature/data_layer/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDataSource {
  final FirebaseFirestore firestore;
  final SharedPreferences prefs;
  static const key = 'recent_users';

  RemoteDataSource(this.firestore, this.prefs);

  Future<List<UserModel>> searchUsers(String query) async {
    final snapshot = await firestore.collection('users').get();
    final q = query.toLowerCase();
    return snapshot.docs
        .map((d) => UserModel.fromFirestore(d))
        .where((u) => u.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> saveUser(UserModel user) async {
    final users = await getUsers();

    users.removeWhere((u) => u.name == user.name);

    users.insert(0, user);

    final jsonList = users.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  Future<List<UserModel>> getUsers() async {
    final data = prefs.getStringList(key);
    if (data == null) return [];
    return data.map((e) => UserModel.fromJson(jsonDecode(e))).toList();
  }

  Future<void> clearUsers() async {
    await prefs.remove(key);
  }
}
