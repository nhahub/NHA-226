import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/friend_account/widget/friend_account_button.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:lingo_sign/features/home/presentation/bloc/friends/friends_bloc.dart';

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
              width: isTablet ? context.width * 0.5 : context.width - 32,
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
                        backgroundColor: AppColor.white,
                        backgroundImage: friend.imageUrl.isNotEmpty
                            ? NetworkImage(friend.imageUrl)
                            : AssetImage('assets/images/placeholder_user.jpg'),
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
                      SizedBox(height: 16.h),
                      BlocConsumer(
                        listener: (context, state) {
                          if (state is FriendSuccessState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (state is FriendsError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  state.message,
                                  style: TextStyle(color: AppColor.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        bloc: context.read<FriendsBloc>(),
                        builder: (context, state) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FriendAccountButton(
                              onTap: () {
                                context.read<FriendsBloc>().add(
                                  friend.isFavourite
                                      ? RemoveFromFavouriteEvent(friend.uid)
                                      : AddToFavouriteEvent(friend.uid),
                                );
                              },
                              isTablet: isTablet,
                              friend: friend,
                              text: friend.isFavourite
                                  ? 'UnFavourite'
                                  : 'Favourite',
                            ),
                            FriendAccountButton(
                              isTablet: isTablet,
                              friend: friend,
                              text: 'Unfriend',
                              onTap: () {
                                context.read<FriendsBloc>().add(
                                  UnfriendEvent(friend.uid),
                                );
                              },
                            ),
                            FriendAccountButton(
                              isTablet: isTablet,
                              friend: friend,
                              text: 'Call',
                              onTap: () {},
                            ),
                          ],
                        ),
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
