import 'package:flutter/material.dart';
import 'package:lingo_sign/features/call/call_system/call_service.dart';
import 'package:lingo_sign/features/call/call_system/firestore_call_model.dart';
import 'package:lingo_sign/features/call/screen/video_screen.dart';

class IncomingCallScreen extends StatelessWidget {
  final Call call;

  const IncomingCallScreen({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Incoming video call"),
            Text("From: ${call.callerId}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CallScreen(channelName: call.channel),
                      ),
                    );
                  },
                  child: Text("Answer"),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    await CallService().endCall(call.receiverId);
                    Navigator.pop(context);
                  },
                  child: Text("Reject"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
