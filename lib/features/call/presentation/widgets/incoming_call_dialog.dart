import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_bloc.dart';
import 'package:lingo_sign/features/call/presentation/screen/video_call_screen.dart';

class IncomingCallDialog extends StatelessWidget {
  final CallEntity callData;
  const IncomingCallDialog({super.key, required this.callData});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.call, size: 64, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              callData.callerName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              callData.isVideoCall ? 'Video Call' : 'Voice Call',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<CallBloc>().add(
                      DeclineCallEvent(callId: callData.callId),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.call_end),
                  label: const Text('Decline'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<CallBloc>().add(
                      AcceptCallEvent(callId: callData.callId),
                    );
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoCallScreen(
                          callID: callData.callId,
                          isVideoCall: callData.isVideoCall,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.call),
                  label: const Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
