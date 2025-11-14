import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FriendUserCallCard extends StatelessWidget {
  const FriendUserCallCard({super.key, required this.userFriend, this.onTap});

  final Friend userFriend;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
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
                      : AssetImage('assets/images/placeholder_user.jpg'),
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
                      userFriend.lastSeen,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              // onTap: () {
              //   ZegoSendCallInvitationButton(
              //     isVideoCall: true,
              //     resourceID: "zegouikit_call",
              //     invitees: [
              //       ZegoUIKitUser(
              //         id: userFriend.uid,
              //         name: userFriend.name,
              //       ),
              //     ],
              //   );
              // },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColor.main,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.call, color: AppColor.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
