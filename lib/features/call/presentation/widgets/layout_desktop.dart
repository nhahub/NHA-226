import 'package:flutter/material.dart';
import 'package:lingo_sign/features/call/domain/participants.dart';
import 'package:lingo_sign/features/call/presentation/widgets/video_tile.dart';

class LayoutDesktop extends StatelessWidget {
final List<Participants> participants;
const LayoutDesktop({super.key, required this.participants});


@override
Widget build(BuildContext context) {
return GridView.builder(
padding: const EdgeInsets.all(24),
gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
maxCrossAxisExtent: 300,
crossAxisSpacing: 20,
mainAxisSpacing: 20,
childAspectRatio: 0.8,
),
itemCount: participants.length,
itemBuilder: (context, index) {
return VideoTile(participants: participants[index]);
},
);
}
}