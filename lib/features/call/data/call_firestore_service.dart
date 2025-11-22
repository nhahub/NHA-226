import 'package:cloud_firestore/cloud_firestore.dart';

class CallFirestoreService {
  final FirebaseFirestore lingoDb = FirebaseFirestore.instance;

  Future<void> createIncomingCall({
    required String receiverId,
    required Map<String, dynamic> data,
  }) async {
    final ref = lingoDb
        .collection('users')
        .doc(receiverId)
        .collection('call')
        .doc('incoming');
    await ref.set(data);
  }

  Future<void> deleteIncomingCall(String userId) async {
    final ref = lingoDb
        .collection('users')
        .doc(userId)
        .collection('call')
        .doc('incoming');
    await ref.delete();
  }

  Stream<Map<String, dynamic>?> onIncomingCall(String userId) {
    final ref = lingoDb
        .collection('users')
        .doc(userId)
        .collection('call')
        .doc('incoming');
        
    return ref.snapshots().map((snap) {
      if (!snap.exists) return null;
      return Map<String, dynamic>.from(snap.data()!);
    });
  }
}
