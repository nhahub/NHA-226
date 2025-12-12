import 'package:lingo_sign/features/call/domain/call_entity.dart';

class Friend {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final DateTime lastSeen;
  final bool isFavourite;
  final CallEntity? call;

  Friend({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastSeen,
    required this.isFavourite,
    this.call,
  });
}
