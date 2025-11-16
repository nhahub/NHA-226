import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? imageUrl; 
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.createdAt, 
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? 'No name',
      email: map['email'] ?? 'No email',
      imageUrl: map['image_url'], 
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

 
  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date);
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'image_url': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}