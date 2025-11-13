import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FriendModel {
  final String uid;
  final bool isFavourite;

  FriendModel({required this.uid, required this.isFavourite});

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(uid: json['uid'], isFavourite: json['is_favourite']);
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'is_favourite': isFavourite};
  }

  Friend toFriend(String name, String imageUrl, String lastSeen) {
    return Friend(
      uid: uid,
      name: name,
      imageUrl: imageUrl,
      lastSeen: lastSeen,
      isFavourite: isFavourite,
    );
  }
}
