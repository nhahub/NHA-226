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
                  style: TextStyle(color: AppColor.white),
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
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(updatedFriend.imageUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      updatedFriend.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    const SizedBox(height: 25),

                    SizedBox(
                      width: 150,
                      height: 50,
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
                          style: const TextStyle(
                            color: AppColor.black,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: 150,
                      height: 50,
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
                        child: const Text(
                          'Unfriend',
                          style: TextStyle(color: AppColor.black, fontSize: 17),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: 150,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColor.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Call',
                          style: TextStyle(color: AppColor.black, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
