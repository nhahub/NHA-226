import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class LastCallModel {
  final String uid;
  final DateTime createdAt;

  LastCallModel({required this.uid, required this.createdAt});

  factory LastCallModel.fromJson(Map<String, dynamic> json) {
    return LastCallModel(
      uid: json['uid'],
      createdAt: (json['created_at'] is Timestamp)
          ? (json['created_at'] as Timestamp).toDate()
          : DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'created_at': createdAt};
  }

  Friend toFriend({
    required String name,
    required String email,
    required String imageUrl,
    required isFavourite,
  }) {
    return Friend(
      uid: uid,
      name: name,
      email: email,
      imageUrl: imageUrl,
      lastSeen: createdAt,
      isFavourite: isFavourite,
    );
  }
}
