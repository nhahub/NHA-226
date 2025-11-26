import 'package:flutter/material.dart';
import 'package:lingo_sign/features/call/controllers/call_controller.dart';
import 'package:lingo_sign/features/call/domain/participants.dart';
import 'package:lingo_sign/features/call/presentation/widgets/bottom_controlls.dart';
import '../widgets/video_tile.dart';

class VideoMeetingScreen extends StatefulWidget {
  const VideoMeetingScreen({super.key});

  @override
  State<VideoMeetingScreen> createState() => _VideoMeetingScreenState();
}

class _VideoMeetingScreenState extends State<VideoMeetingScreen> {
  final CallController callController = CallController();
  List<Participants> participants = [];

  @override
  void initState() {
    super.initState();
    callController.initEngine().then((_) {
      setState(() {
        participants = [Participants(name: 'You', uid: 0, isYou: true)];
      });
      callController.addListener(_updateParticipants);
    });
  }

  void _updateParticipants() {
    setState(() {
      final remoteUsers = callController.users.where((uid) => uid != 0);
      participants = [
        Participants(name: 'You', uid: 0, isYou: true),
        ...remoteUsers.map((uid) => Participants(name: 'User $uid', uid: uid)),
      ];
    });
  }

  @override
  void dispose() {
    callController.leaveChannel();
    callController.removeListener(_updateParticipants);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxis = width < 600 ? 1 : 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxis,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: participants.length,
                itemBuilder: (context, index) => VideoTile(
                  participant: participants[index],
                  callController: callController,
                ),
              ),
            ),
            BottomControls(
              // callController: callController,
              endCall: () async {
                await callController.leaveChannel();
                // ignore: use_build_context_synchronously
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
