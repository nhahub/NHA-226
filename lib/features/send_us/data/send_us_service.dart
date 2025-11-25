import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SendEmailService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  Future<void> sendEmail(String message) async {
    String uid=firebaseAuth.currentUser!.uid;
    String? email=firebaseAuth.currentUser?.email;
    String? name=firebaseAuth.currentUser?.displayName;
    await firestore.collection('suggestions_and_complaints').add({
      'user_email':email ?? 'unknown email',
      'user_name':name ?? 'unknown name',
      'user_id': uid,
      'message': message,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
