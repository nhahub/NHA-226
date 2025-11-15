import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/friend_account/widget/friend_account_button.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FriendAccountScreen extends StatelessWidget {
  final Friend friend;
  final void Function()? onClose;

  const FriendAccountScreen({super.key, required this.friend, this.onClose});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.width > 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: onClose ?? () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black.withAlpha(30)),
            ),
          ),
          Center(
            child: SizedBox(
              width: isTablet ? context.width * 0.5 : context.width * 0.85,
              child: Card(
                color: AppColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 30 : 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: isTablet ? 60 : 40,
                        backgroundImage: NetworkImage(friend.imageUrl),
                      ),
                      SizedBox(height: context.height * 0.02),

                      Text(
                        friend.name,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),

                      SizedBox(height: context.height * 0.001),
                      Text(
                        friend.email,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 18,
                          fontWeight: FontWeight.w500,
                          color: AppColor.gray,
                        ),
                      ),
                      SizedBox(height: context.height * 0.004),

                      FriendAccountButton(
                        isTablet: isTablet,
                        friend: friend,
                        text: friend.isFavourite ? 'UnFavourite' : 'Favourite',
                      ),

                      SizedBox(height: context.height * 0.02),
                      FriendAccountButton(
                        isTablet: isTablet,
                        friend: friend,
                        text: 'Unfriend',
                      ),

                      SizedBox(height: context.height * 0.02),
                      FriendAccountButton(
                        isTablet: isTablet,
                        friend: friend,
                        text: 'Call',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
