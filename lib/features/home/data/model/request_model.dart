import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/home/domain/entities/request.dart';

class RequestModel {
  final String uid;
  final String status;
  final DateTime createdAt;

  RequestModel({
    required this.uid,
    required this.status,
    required this.createdAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      uid: json['uid'],
      status: json['status'],
      createdAt: (json['created_at'] is Timestamp)
          ? (json['created_at'] as Timestamp).toDate()
          : DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'status': status, 'created_at': createdAt};
  }

  Request toRequste({required String name, required String imageUrl}) {
    return Request(
      uid: uid,
      name: name,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }
}
