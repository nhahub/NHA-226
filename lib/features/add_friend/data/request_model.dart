import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String uid;
  final String status;
  final DateTime createdAt;

  RequestModel({
    required this.uid,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory RequestModel.fromJson(Map<String, dynamic> map) {
    final created = map['created_at'];
    DateTime createdAt;
    if (created is Timestamp) {
      createdAt = created.toDate();
    } else if (created is String) {
      createdAt = DateTime.parse(created);
    } else if (created is DateTime) {
      createdAt = created;
    } else {
      createdAt = DateTime.now();
    }

    return RequestModel(
      uid: map['uid'],
      status: map['status'],
      createdAt: createdAt,
    );
  }
}
