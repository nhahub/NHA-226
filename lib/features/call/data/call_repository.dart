import 'package:cloud_firestore/cloud_firestore.dart';
import 'call_firestore_service.dart';

class CallRepository {
  final CallFirestoreService fs;
  CallRepository(this.fs);

  Future<void> startCall({
    required String callerId,
    required String receiverId,
    required String channelName,
    required String token,
  }) async {
    final data = {
      'callerId': callerId,
      'channelName': channelName,
      'token': token,
      'status': 'ringing',
      'timestamp': FieldValue.serverTimestamp(),
    };
    await fs.createIncomingCall(receiverId: receiverId, data: data);
    final callerRef = FirebaseFirestore.instance
        .collection('users')
        .doc(callerId)
        .collection('call')
        .doc('outgoing');
    await callerRef.set({
      'calleeId': receiverId,
      'channelName': channelName,
      'token': token,
      'status': 'calling',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptCall({required String receiverId}) async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('call')
        .doc('incoming');
    final snap = await ref.get();
    if (!snap.exists) return;
    final data = snap.data()!;
    final callerId = data['callerId'] as String?;
    await ref.update({'status': 'accepted'});
    if (callerId != null) {
      final callerRef = FirebaseFirestore.instance
          .collection('users')
          .doc(callerId)
          .collection('call')
          .doc('outgoing');
      await callerRef.update({'status': 'accepted'});
    }
  }

  Future<void> declineCall({required String receiverId}) async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('call')
        .doc('incoming');
    final snap = await ref.get();
    if (!snap.exists) return;
    final data = snap.data()!;
    final callerId = data['callerId'] as String?;
    await ref.delete();
    if (callerId != null) {
      final callerRef = FirebaseFirestore.instance
          .collection('users')
          .doc(callerId)
          .collection('call')
          .doc('outgoing');
      await callerRef.delete();
    }
  }

  Future<void> endCall({required String userId}) async {
    final incomingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('call')
        .doc('incoming');
    final outgoingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('call')
        .doc('outgoing');
    final inc = await incomingRef.get();
    final out = await outgoingRef.get();
    if (inc.exists) {
      final callerId = inc.data()?['callerId'] as String?;
      await incomingRef.delete();
      if (callerId != null && callerId != userId) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(callerId)
            .collection('call')
            .doc('outgoing')
            .delete();
      }
    }
    if (out.exists) {
      final calleeId = out.data()?['calleeId'] as String?;
      await outgoingRef.delete();
      if (calleeId != null && calleeId != userId) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(calleeId)
            .collection('call')
            .doc('incoming')
            .delete();
      }
    }
  }

  Stream<Map<String, dynamic>?> incomingStream(String userId) =>
      fs.onIncomingCall(userId);
}
