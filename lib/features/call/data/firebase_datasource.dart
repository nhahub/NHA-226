import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/call/data/call_model.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CallModel> makeCall({
    required String receiverId,
    required String receiverName,
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
      receiverName: receiverName,
      startTime: DateTime.now(),
      type: CallEntityType.pending,
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

    return snapshot.docs.map((doc) => CallModel.fromJson(doc.data())).toList();
  }

  Future<void> updateCallStatus(String callId, String status) async {
    try {
      // ignore: avoid_print
      print(
        '[FirebaseDataSource] Updating call status: callId=$callId, status=$status',
      );

      await _firestore.collection('calls').doc(callId).update({
        'status': status,
        'endTime': status == 'ended' ? DateTime.now().toIso8601String() : null,
      });

      // ignore: avoid_print
      print('[FirebaseDataSource] Call status updated successfully');
    } catch (e) {
      // ignore: avoid_print
      print('[FirebaseDataSource] Error updating call status: $e');
      rethrow;
    }
  }

  Stream<CallModel> listenToIncomingCalls(String userId) {
    return _firestore
        .collection('calls')
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return CallModel.fromJson(snapshot.docs.first.data());
          }
          // Return empty/default pending call instead of throwing error
          /*
            return CallModel(
              callId: '',
              callerId: '',
              callerName: '',
              receiverId: '',
              receiverName: '',
              startTime: DateTime.now(),
              type: CallEntityType.pending,
              duration: 0,
              isVideoCall: false,
            );
          */
          throw Exception('No incoming calls');
          
        })
        .handleError((error) {
          // ignore: avoid_print
          print('Error listening to incoming calls: $error');
          // Continue stream on error instead of breaking it
          throw error;
        });
  }
}
