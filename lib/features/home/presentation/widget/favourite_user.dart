import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FavouriteUser extends StatelessWidget {
  const FavouriteUser({super.key, required this.userFavourite});

  final Friend userFavourite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColor.white,
            backgroundImage: userFavourite.imageUrl.isNotEmpty
                ? NetworkImage(userFavourite.imageUrl)
                : AssetImage('assets/images/placeholder_user.jpg'),
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
