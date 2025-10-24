import 'dart:convert';
import 'package:lingo_sign/search_feature/data_layer/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  final SharedPreferences prefs;
  static const key = 'recent_users';

  LocalDataSource(this.prefs);

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
