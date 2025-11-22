import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/call/data/call_firestore_service.dart';
import 'package:lingo_sign/features/call/data/call_repository.dart';
import 'package:lingo_sign/features/call/presentation/screens/incoming_handler.dart';
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
    IncomingHandler(myUserId: auth.currentUser!.uid);
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
                onTap: () async {
                  await CallFirestoreService().createIncomingCall(
                    receiverId: userFriend.uid,
                    data: {
                      "callerId": auth.currentUser!.uid,
                      "callerName": auth.currentUser!.displayName ?? "Unknown",
                      "callerAvatar": auth.currentUser!.photoURL ?? "",
                      "callId": DateTime.now().millisecondsSinceEpoch
                          .toString(),
                      "channelName":
                          "agora_channel_${DateTime.now().millisecondsSinceEpoch}",
                      "token": "<TEMP_TOKEN>",
                      "timestamp": DateTime.now().millisecondsSinceEpoch,
                    },
                  );
                  final callerId = auth.currentUser!.uid;
                  final calleeId = userFriend.uid;
                  final channel =
                      'call_${callerId}_$calleeId${DateTime.now().millisecondsSinceEpoch}';
                  final token = "<TEMP_TOKEN>";
                  final repo = CallRepository(CallFirestoreService());
                  await repo.startCall(
                    callerId: callerId,
                    receiverId: calleeId,
                    channelName: channel,
                    token: token,
                  );
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
}
