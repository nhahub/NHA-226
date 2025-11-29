// lib/data/datasources/firebase_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/call/data/call_model.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CallModel> makeCall({
    required String receiverId,
    required String callerId,
    required String callerName,
    required bool isVideoCall,
  }) async {
    final callId = DateTime.now().millisecondsSinceEpoch.toString();
    final callModel = CallModel(
      callId: callId,
      callerId: callerId,
      callerName: callerName,
      receiverId: receiverId,
      receiverName: 'User $receiverId',
      startTime: DateTime.now(),
      status: 'pending',
      duration: 0,
      isVideoCall: isVideoCall,
    );

    await _firestore.collection('calls').doc(callId).set(callModel.toJson());
    return callModel;
  }

  Future<List<CallModel>> getCallHistory(String userId) async {
    final snapshot = await _firestore
        .collection('calls')
        .where('receiverId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CallModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateCallStatus(String callId, String status) async {
    await _firestore.collection('calls').doc(callId).update({
      'status': status,
      'endTime': DateTime.now().toIso8601String(),
    });
  }

  Stream<CallModel> listenToIncomingCalls(String userId) {
    return _firestore
        .collection('calls')
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => CallModel.fromJson(snapshot.docs.last.data()));
  }
}
