import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/widget/message.dart';
import 'package:lingo_sign/features/add_friend/presentation/cubit/friend_request_cubit.dart';
import 'package:lingo_sign/features/add_friend/presentation/widget/add_friend.dart';
import 'package:lingo_sign/features/home/presentation/bloc/friends/friends_bloc.dart';
import 'package:lingo_sign/features/home/presentation/widget/favourite_user.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call_card.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({super.key});
  FirebaseAuth auth = FirebaseAuth.instance;

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
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Favourites",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 90.h,
                child: BlocBuilder<FriendsBloc, FriendsState>(
                  builder: (context, state) {
                    if (state is FriendsLoaded) {
                      final favourites = state.friends
                          .where((favourite) => favourite.isFavourite)
                          .toList();

                      if (favourites.isEmpty) {
                        return const Center(child: Text('No favourites yet'));
                      }

                      return ListView.builder(
                        padding: EdgeInsets.only(left: 16.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: favourites.length,
                        itemBuilder: (context, index) {
                          return FavouriteUser(
                            userFavourite: favourites[index],
                          );
                        },
                      );
                    }
                    if (state is FriendsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Center(child: Text('Error'));
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Friends",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<FriendsBloc, FriendsState>(
                  builder: (context, state) {
                    if (state is FriendsLoaded) {
                      final friends = state.friends;
                      if (friends.isEmpty) {
                        return const Center(child: Text('Start add friends'));
                      }
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              return FriendUserCallCard(
                                userFriend: friends[index],
                                onTap: () {},
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 200.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor.main,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        topRight: Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Create Meeting'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text('Meeting'),
                          ),
                        ],
                      );
                    }
                    if (state is FriendsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Center(child: Text('Error'));
                  },
                ),
              ),
            ],
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
              return const AddFriend();
            },
          ),
    );
  }
}
