import 'package:flutter/material.dart';
import 'package:lingo_sign/features/meeting_call/domain/models/Participants.dart';
import 'package:lingo_sign/features/meeting_call/presentation/widgets/video_tile.dart';

class LayoutMobile extends StatelessWidget {
  final List<Participants> participants;
  const LayoutMobile({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return VideoTile(participants: participants[index]);
      },
    );
  }
}
