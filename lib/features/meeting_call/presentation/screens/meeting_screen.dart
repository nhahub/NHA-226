import 'package:flutter/material.dart';
import 'package:lingo_sign/features/meeting_call/domain/models/Participants.dart';
import 'package:lingo_sign/features/meeting_call/presentation/widgets/bottom_controlls.dart';
import 'package:lingo_sign/features/meeting_call/presentation/widgets/layout_desktop.dart';
import 'package:lingo_sign/features/meeting_call/presentation/widgets/layout_mobile.dart';
import 'package:lingo_sign/features/meeting_call/presentation/widgets/meeting_header.dart';


class VideoMeetingScreen extends StatefulWidget {
  const VideoMeetingScreen({super.key});

  @override
  State<VideoMeetingScreen> createState() => _VideoMeetingScreenState();
}

class _VideoMeetingScreenState extends State<VideoMeetingScreen> {
  final List<Participants> participants = [
    Participants(name: 'Maryna', isSpeaking: true, isYou: false),
    Participants(name: 'You', isSpeaking: false, isYou: true),
    Participants(name: 'Alex', isSpeaking: false, isYou: false),
    Participants(name: 'Sarah', isSpeaking: false, isYou: false),
    Participants(name: 'Mike', isSpeaking: false, isYou: false),
    Participants(name: 'Emma', isSpeaking: false, isYou: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            const MeetingHeader(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return LayoutMobile(participants: participants);
                  } else {
                    return LayoutDesktop(participants: participants);
                  }
                },
              ),
            ),
            const BottomControls(),
          ],
        ),
      ),
    );
  }
}
