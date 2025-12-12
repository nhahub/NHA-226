import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/string.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_bloc.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key, required this.call});

  final CallEntity call;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late CallBloc callBloc;

  @override
  void initState() {
    super.initState();
    callBloc = context.read<CallBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
        appID: appId,
        appSign: appSign,
        userID: user!.uid,
        userName: user.displayName ?? 'UserName',
        callID: widget.call.callId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        onDispose: () {
          callBloc.add(
            EndCallEvent(
              callerId: widget.call.callerId,
              receiverId: widget.call.receiverId,
            ),
          );
        },
      ),
    );
  }
}
