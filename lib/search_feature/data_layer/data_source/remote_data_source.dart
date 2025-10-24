import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/search_feature/data_layer/model/user_model.dart';

class RemoteDataSource {
  final FirebaseFirestore firestore;
  RemoteDataSource(this.firestore);

  Future<List<UserModel>> searchUsers(String query) async {
    final snapshot = await firestore.collection('users').get();
    final q = query.toLowerCase();
    return snapshot.docs
        .map((d) => UserModel.fromFirestore(d))
        .where((u) => u.name.toLowerCase().contains(q))
        .toList();
  }
}
