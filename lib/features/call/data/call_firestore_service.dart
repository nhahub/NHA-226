import 'package:cloud_firestore/cloud_firestore.dart';

class CallFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createMeeting(
    String meetingId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('meetings').doc(meetingId).set(data);
  }

  Future<void> joinMeeting(
    String meetingId,
    Map<String, dynamic> participant,
  ) async {
    await _firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('participants')
        .doc(participant['uid'])
        .set(participant);
  }

  Future<void> leaveMeeting(String meetingId, String uid) async {
    await _firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('participants')
        .doc(uid)
        .delete();
  }

  Stream<QuerySnapshot> getParticipantsStream(String meetingId) {
    return _firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('participants')
        .snapshots();
  }

  Future<void> endMeeting(String meetingId) async {
    await _firestore.collection('meetings').doc(meetingId).delete();
  }
}
