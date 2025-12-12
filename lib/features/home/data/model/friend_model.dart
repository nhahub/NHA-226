import 'package:lingo_sign/features/call/data/call_model.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FriendModel {
  final String uid;
  final bool isFavourite;
  final CallEntity? call;

  FriendModel({required this.uid, required this.isFavourite, this.call});

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      uid: json['uid'],
      isFavourite: json['is_favourite'],
      call: json['call'] != null ? CallModel.fromJson(json['call']) : null,
    );
  }

  factory FriendModel.fromFriend(Friend friend) {
    return FriendModel(
      uid: friend.uid,
      isFavourite: friend.isFavourite,
      call: friend.call,
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'is_favourite': isFavourite};
  }

  Friend toFriend({
    required String name,
    required String email,
    required String imageUrl,
    required DateTime lastSeen,
    CallEntity? call,
  }) {
    return Friend(
      uid: uid,
      name: name,
      email: email,
      imageUrl: imageUrl,
      lastSeen: lastSeen,
      isFavourite: isFavourite,
      call: call,
    );
  }
}
