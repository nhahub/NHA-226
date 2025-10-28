import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  AccountRepository(this.firestore, this.auth);

  Future<Map<String, dynamic>> loadUserData() async {
    final userId = auth.currentUser!.uid;
    final snapshot = await firestore.collection('users').doc(userId).get();
    return snapshot.data() ?? {};
  }

  Future<void> updateUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    final userId = auth.currentUser!.uid;
    await firestore.collection('users').doc(userId).update({
      'name': name,
      'email': email,
      'phone': phone,
    });
  }
}
