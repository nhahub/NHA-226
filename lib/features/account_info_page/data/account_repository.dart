import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> loadUserData() async {
    final userId = firebaseAuth.currentUser!.uid;
    final snapshot = await firebaseFirestore.collection('users').doc(userId).get();
    return snapshot.data() ?? {};
  }

  Future<void> updateUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    final userId = firebaseAuth.currentUser!.uid;
    await firebaseFirestore.collection('users').doc(userId).update({
      'name': name,
      'email': email,
      'phone': phone,
    });
  }
}
