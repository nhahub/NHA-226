import 'package:flutter/material.dart';
import 'package:lingo_sign/features/call/domain/participants.dart';
import 'package:lingo_sign/features/call/presentation/widgets/video_tile.dart';

class LayoutMobile extends StatelessWidget {
  final List<Participants> participants;
  const LayoutMobile({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return VideoTile(participants: participants[index]);
      },
    );
  }
}
