import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/friend_account/screen/freind_account_screen.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FavouriteUser extends StatelessWidget {
  const FavouriteUser({super.key, required this.userFavourite});

  final Friend userFavourite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) => FriendAccountScreen(friend: userFavourite),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          width: context.width / 4.8,
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColor.white,
                backgroundImage: userFavourite.imageUrl.isNotEmpty
                    ? NetworkImage(userFavourite.imageUrl)
                    : const AssetImage('assets/images/placeholder_user.jpg'),
              ),
              const SizedBox(height: 6),
              Text(
                userFavourite.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
