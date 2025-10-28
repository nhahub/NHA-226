import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserData() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  Future<void> updateUserData({
    String? name,
    String? email,
    String? phone,
  }) async {
    final uid = _auth.currentUser!.uid;
    final Map<String, dynamic> updates = {};

    if (name != null && name.isNotEmpty) updates['name'] = name;
    if (phone != null && phone.isNotEmpty) updates['phone'] = phone;
    if (email != null && email.isNotEmpty) updates['email'] = email;

    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(updates);
    }
  }
}
