import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/string.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key, required this.callID, this.isVideoCall});

  final String callID;
  final bool? isVideoCall;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final config = isVideoCall == true
        ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
        appID: appId,
        appSign: appSign,
        userID: user!.uid,
        userName: user.displayName ?? 'UserName',
        callID: callID,
        config: config,
      ),
    );
  }
}
