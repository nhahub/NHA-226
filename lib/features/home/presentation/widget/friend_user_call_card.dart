import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_bloc.dart';
import 'package:lingo_sign/features/call/presentation/screen/video_call_screen.dart';
import 'package:lingo_sign/features/friend_account/screen/freind_account_screen.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:timeago/timeago.dart' as timeago;

class FriendUserCallCard extends StatelessWidget {
  const FriendUserCallCard({super.key, required this.userFriend, this.onTap});

  final Friend userFriend;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) => FriendAccountScreen(friend: userFriend),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: userFriend.call != null
                ? null // Border.all(color: AppColor.main, width: 2)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColor.white,
                    backgroundImage: userFriend.imageUrl.isNotEmpty
                        ? NetworkImage(userFriend.imageUrl)
                        : const AssetImage(
                            'assets/images/placeholder_user.jpg',
                          ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userFriend.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeago.format(userFriend.lastSeen),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              BlocBuilder<CallBloc, CallState>(
                builder: (context, state) {
                  bool isLoading =
                      state is CallLoading && state.friendId == userFriend.uid;

                  return InkWell(
                    onTap: () {
                      if (isLoading) return;

                      if (userFriend.call != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoCallScreen(
                              callID: userFriend.call!.callId,
                              isVideoCall: userFriend.call!.isVideoCall,
                            ),
                          ),
                        );
                      } else {
                        context.read<CallBloc>().add(
                          MakeCallEvent(receiverId: userFriend.uid),
                        );
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColor.main,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: isLoading
                          ? Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                color: AppColor.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              userFriend.call != null
                                  ? Icons.door_back_door_outlined
                                  : Icons.call,
                              color: AppColor.white,
                              size: 20,
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
