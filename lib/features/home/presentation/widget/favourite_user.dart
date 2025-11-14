import 'package:flutter/material.dart';
import 'package:lingo_sign/features/home/domain/entities/user_favourite.dart';

class FavouriteUser extends StatelessWidget {
  const FavouriteUser({super.key, required this.userFavourite});

  final UserFavourite userFavourite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(userFavourite.imageUrl),
          ),
          const SizedBox(height: 6),
          Text(
            userFavourite.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
