import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
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
          color: Colors.transparent,
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
              InkWell(
                onTap: () {
                  // context.read<CallBloc>().add(
                  //   MakeCallEvent(
                  //     receiverId: userFriend.uid,
                  //     receiverName: userFriend.name,
                  //     isVideoCall: true,
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VideoCallScreen(
                          callID: 'test-call-9999',
                          isVideoCall: true,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColor.main,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.call,
                    color: AppColor.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
