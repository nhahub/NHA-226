import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/data/home_repository_impl.dart';
import 'package:lingo_sign/features/home/presentation/bloc/friends/friends_bloc.dart';
import 'package:lingo_sign/features/home/presentation/widget/custom_floating_action_button.dart';
import 'package:lingo_sign/features/home/presentation/widget/favourite_user.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call_card.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: BlocProvider(
            create: (context) =>
                FriendsBloc(HomeRepositoryImpl())..add(GetAllFriend()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: const Text(
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
                        return Center(child: CircularProgressIndicator());
                      }
                      return Center(child: Text('Error'));
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: const Text(
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
                          return Center(child: Text('Start add friends'));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            return FriendUserCallCard(
                              userFriend: friends[index],
                              onTap: () {},
                            );
                          },
                        );
                      }
                      if (state is FriendsLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Center(child: Text('Error'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}
