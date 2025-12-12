import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/call/data/call_model.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<CallModel> makeCall({
    required String receiverId,
    required String callerId,
    required String callerName,
    required bool isVideoCall,
  }) async {
    var user = _firebaseAuth.currentUser;
    final callId = DateTime.now().millisecondsSinceEpoch.toString();
    final callModel = CallModel(
      callId: callId,
      callerId: callerId,
      callerName: callerName,
      receiverId: receiverId,
      startTime: DateTime.now(),
      type: CallEntityType.pending,
      duration: 0,
      isVideoCall: isVideoCall,
    );

    await _firestore
        .collection('users')
        .doc(receiverId)
        .collection('friends')
        .doc(user!.uid)
        .set({'call': callModel.toJson()}, SetOptions(merge: true));

    return callModel;
  }

  Future<CallModel> joinToCall({required String callerId}) async {
    var user = _firebaseAuth.currentUser;
    final snapshot = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('friends')
        .doc(callerId)
        .get();

    if (!snapshot.exists) {
      throw Exception("Call does not exist");
    }

    final call = CallModel.fromJson(snapshot.data()!['call']);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .doc(callerId)
        .set({
          'call': {'type': CallEntityType.active.name},
        }, SetOptions(merge: true));

    return call.copyWith(type: CallEntityType.active);
  }

  Future<void> endCall({
    required String callerId,
    required String receiverId,
  }) async {
    await _firestore
        .collection('users')
        .doc(receiverId)
        .collection('friends')
        .doc(callerId)
        .update({'call': FieldValue.delete()});
  }
}
