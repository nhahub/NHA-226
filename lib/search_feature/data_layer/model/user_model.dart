import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String image;

  UserModel({required this.name, required this.image});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(name: data['name'] ?? '', image: data['image'] ?? '');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(name: json['name'] ?? '', image: json['image'] ?? '');

  Map<String, dynamic> toJson() => {'name': name, 'image': image};
}
