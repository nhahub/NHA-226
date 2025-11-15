import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/friend_account/Freind.dart';
import 'package:lingo_sign/features/friend_account/Screen/state_managment/freind_bloc.dart';
import 'package:lingo_sign/features/friend_account/Screen/state_managment/friend_events.dart';
import 'package:lingo_sign/features/friend_account/Screen/state_managment/friend_states.dart';
import 'package:lingo_sign/features/friend_account/friend_data/friend_data_source.dart';
import 'package:lingo_sign/features/friend_account/friend_data/friend_repository.dart';

class FriendAccountScreen extends StatelessWidget {
  final Friend friend;

  const FriendAccountScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.width > 600;

    return BlocProvider(
      create: (_) => FriendBloc(
        FriendRepository(
          FriendDataSource(FirebaseFirestore.instance, FirebaseAuth.instance),
        ),
      )..add(LoadFriendEvent(friend.uid)),
      child: BlocConsumer<FriendBloc, FriendState>(
        listener: (context, state) {
          if (state is FriendSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is FriendErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: const TextStyle(color: AppColor.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FriendLoadingState || state is FriendInitialState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FriendErrorState) {
            return Center(child: Text("Error: ${state.error}"));
          }

          if (state is! FriendLoadedState) {
            return const Center(child: CircularProgressIndicator());
          }

          final updatedFriend = state.friend;

          return Center(
            child: SizedBox(
              width: isTablet ? context.width * 0.5 : context.width * 0.85,
              child: Card(
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
                        backgroundImage: NetworkImage(updatedFriend.imageUrl),
                      ),
                      SizedBox(height: context.height * 0.02),

                      Text(
                        updatedFriend.name,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),

                      SizedBox(height: context.height * 0.04),

                      SizedBox(
                        width: isTablet ? 200 : 150,
                        height: isTablet ? 60 : 50,
                        child: OutlinedButton(
                          onPressed: () {
                            if (updatedFriend.isFavourite) {
                              context.read<FriendBloc>().add(
                                RemoveFromFavouriteEvent(updatedFriend.uid),
                              );
                            } else {
                              context.read<FriendBloc>().add(
                                AddToFavouriteEvent(updatedFriend.uid),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColor.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            updatedFriend.isFavourite
                                ? 'Unfavourite'
                                : 'Favourite',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: isTablet ? 20 : 17,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: context.height * 0.02),

                      SizedBox(
                        width: isTablet ? 200 : 150,
                        height: isTablet ? 60 : 50,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<FriendBloc>().add(
                              UnfriendEvent(updatedFriend.uid),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColor.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Unfriend',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: isTablet ? 20 : 17,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: context.height * 0.02),

                      SizedBox(
                        width: isTablet ? 200 : 150,
                        height: isTablet ? 60 : 50,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColor.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Call',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: isTablet ? 20 : 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
