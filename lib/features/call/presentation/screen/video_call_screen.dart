import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/string.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoCallScreen extends StatelessWidget {
  final String callID;
  final bool isVideoCall;

  const VideoCallScreen({
    super.key,
    required this.callID,
    required this.isVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
        appID: appId,
        appSign: appSign,
        userID: user!.uid,
        userName: user.displayName ?? 'User',
        callID: callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
