import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TranslationRepositoryImpl {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> getUserName() async {
    final id = auth.currentUser!.uid;
    try {
      final user = await firestore.collection('users').doc(id).get();
      final name = user['name'];
      return name;
    } catch (e) {
      throw Exception(e);
    }
  }
}
