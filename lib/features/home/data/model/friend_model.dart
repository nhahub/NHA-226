import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FriendModel {
  final String uid;
  final String name;
  final String imageUrl;
  final String lastSeen;
  final bool isFavourite;

  FriendModel({
    required this.uid,
    required this.name,
    required this.imageUrl,
    required this.lastSeen,
    required this.isFavourite,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      uid: json['uid'],
      name: json['name'],
      imageUrl: json['image_url'],
      lastSeen: json['last_seen'],
      isFavourite: json['is_favourite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'image_url': imageUrl,
      'last_seen': lastSeen,
      'is_favourite': isFavourite,
    };
  }

  Friend toFriend() {
    return Friend(
      uid: uid,
      name: name,
      imageUrl: imageUrl,
      lastSeen: lastSeen,
      isFavourite: isFavourite,
    );
  }
}
