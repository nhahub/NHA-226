import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/call/call_system/call_service.dart';
import 'package:lingo_sign/features/call/call_system/firestore_call_model.dart';
import 'package:lingo_sign/features/call/screen/video_screen.dart';
import 'package:lingo_sign/features/friend_account/screen/freind_account_screen.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:timeago/timeago.dart' as timeago;

class FriendUserCallCard extends StatelessWidget {
  FriendUserCallCard({super.key, required this.userFriend, this.onTap});
  FirebaseAuth auth = FirebaseAuth.instance;
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
        padding: const EdgeInsets.only(bottom: 16),
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
                        timeago.format(userFriend.lastSeen),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  _showCallDialog(context, userFriend);
                },
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
      ),
    );
  }

  void _showCallDialog(BuildContext context, Friend friend) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Video Call"),
          content: Text("Call ${friend.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final call = Call(
                  callerId: auth.currentUser!.uid,
                  receiverId: friend.uid,
                  channel: "channel_${friend.uid}",
                  status: "ringing",
                );

                await CallService().makeCall(call);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CallScreen(channelName: call.channel),
                  ),
                );
              },
              child: Text("Call"),
            ),
          ],
        );
      },
    );
  }
}
