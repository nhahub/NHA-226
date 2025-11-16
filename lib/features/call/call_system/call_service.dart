import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/call/call_system/firestore_call_model.dart';


class CallService {
  final calls = FirebaseFirestore.instance.collection("calls");

  Future<void> makeCall(Call call) async {
    await calls.doc(call.receiverId).set(call.toMap());
  }

  Stream<Call?> onIncomingCall(String userId) {
    return calls.doc(userId).snapshots().map((snap) {
      if (!snap.exists) return null;
      return Call.fromMap(snap.data()!);
    });
  }

  Future<void> endCall(String userId) async {
    await calls.doc(userId).delete();
  }
}
