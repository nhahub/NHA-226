import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/home/presentation/bloc/friends/friends_bloc.dart';
import 'package:lingo_sign/features/home/presentation/bloc/last_calls/last_calls_bloc.dart';
import 'package:lingo_sign/features/home/presentation/widget/favourite_user.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call_card.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call_shimmer_card.dart';

class LastCallScreen extends StatelessWidget {
  const LastCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<FriendsBloc, FriendsState>(
                builder: (context, state) {
                  if (state is FriendsLoaded) {
                    final favourites = state.friends
                        .where((favourite) => favourite.isFavourite)
                        .toList();

                    if (favourites.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: context.width * 0.04,
                            ),
                            child: const Text(
                              "Favourites",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: context.height * 0.02),
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
                          SizedBox(height: context.height * 0.02),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }
                  if (state is FriendsLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Center(child: Text('Error'));
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: context.width * 0.04),
                child: const Text(
                  "Last Call",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: context.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<LastCallsBloc, LastCallsState>(
                  builder: (context, state) {
                    if (state is LastCallsLoaded) {
                      final lastCalls = state.lastCalls;
                      if (lastCalls.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: context.height * 0.11),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  child: SvgPicture.asset(
                                    'assets/images/pana.svg',
                                  ),
                                ),
                                SizedBox(height: context.height * 0.03),
                                Text(
                                  'No calls yet',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: AppColor.main,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: lastCalls.length,
                        itemBuilder: (context, index) {
                          return FriendUserCallCard(
                            userFriend: lastCalls[index],
                            onTap: () {},
                          );
                        },
                      );
                    }
                    if (state is LastCallsLoading) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return FriendUserCallShimmerCard();
                        },
                      );
                    }
                    return Center(child: Text('Error'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
