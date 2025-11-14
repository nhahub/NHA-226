import 'package:lingo_sign/features/home/domain/entities/user_app.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? imageUrl;
  final DateTime lastSeen;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['image_url'],
      lastSeen: json['last_seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image_url': imageUrl,
      'last_seen': lastSeen,
    };
  }

  UserApp toUserApp() {
    return UserApp(
      uid: uid,
      name: name,
      email: email,
      imageUrl: imageUrl ?? '',
      lastSeen: lastSeen,
    );
  }
}
