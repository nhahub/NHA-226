import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/widget/message.dart';
import 'package:lingo_sign/features/add_friend/presentation/cubit/friend_request_cubit.dart';
import 'package:lingo_sign/features/add_friend/presentation/widget/add_friend.dart';
import 'package:lingo_sign/features/home/presentation/bloc/friends/friends_bloc.dart';
import 'package:lingo_sign/features/home/presentation/widget/favourite_user.dart';
import 'package:lingo_sign/features/home/presentation/widget/favourite_user_shimmer_cart.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call_card.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call_shimmer_card.dart';
import 'package:lingo_sign/features/home/presentation/widget/text_shimmer.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: BlocBuilder<FriendsBloc, FriendsState>(
            builder: (context, state) {
              if (state is FriendsLoaded) {
                final friends = state.friends;
                final favourites = friends
                    .where((favourite) => favourite.isFavourite)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (favourites.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: const Text(
                          "Favourites",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 90.h,
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 16.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: favourites.length,
                          itemBuilder: (context, index) {
                            return FavouriteUser(
                              userFavourite: favourites[index],
                            );
                          },
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: const Text(
                        "Friends",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (friends.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          return FriendUserCallCard(
                            userFriend: friends[index],
                            onTap: () {},
                          );
                        },
                      ),
                    ],
                  ],
                );
              }
              if (state is FriendsLoading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextShimmer(),
                    SizedBox(
                      height: 90.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 16.h),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return FavouriteUserShimmerCart();
                        },
                      ),
                    ),
                    TextShimmer(),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return FriendUserCallShimmerCard();
                      },
                    ),
                  ],
                );
              }
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: SvgPicture.asset('assets/images/rafiki.svg'),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'No friend requests',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColor.main,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton:
          BlocConsumer<FriendRequestCubit, FriendRequestState>(
            listener: (context, state) {
              if (state is FriendRequestSuccess) {
                Message(
                  context: context,
                  message: 'Friend request sent successfully!',
                  color: Colors.green,
                );
              } else if (state is FriendRequestError) {
                Message(
                  context: context,
                  message: state.message!,
                  color: Colors.red,
                );
              }
            },
            builder: (context, state) {
              return AddFriend();
            },
          ),
    );
  }
}
