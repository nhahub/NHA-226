import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FriendModel {
  final String uid;
  final bool isFavourite;

  FriendModel({required this.uid, required this.isFavourite});

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(uid: json['uid'], isFavourite: json['is_favourite']);
  }

  factory FriendModel.fromFriend(Friend friend) {
  return FriendModel(
    uid: friend.uid,
    isFavourite: friend.isFavourite,
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
  }) {
    return Friend(
      uid: uid,
      name: name,
      email: email,
      imageUrl: imageUrl,
      lastSeen: lastSeen,
      isFavourite: isFavourite,
    );
  }
}
