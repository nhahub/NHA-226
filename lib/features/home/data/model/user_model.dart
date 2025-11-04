import 'package:lingo_sign/features/home/domain/entities/user_app.dart';

class UserModel {
  final String uid;
  final String name;
  final String imageUrl;

  UserModel({required this.uid, required this.name, required this.imageUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'image_url': imageUrl};
  }

  UserApp toUserApp() {
    return UserApp(uid: uid, name: name, imageUrl: imageUrl);
  }
}
