import 'package:flutter/material.dart';
import 'package:lingo_sign/features/meeting_call/presentation/widgets/conrtol_button.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({super.key});

  double _r(double w, double mobile, double desktop) {
    return w < 600 ? mobile : desktop;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _r(width, 16, 32),
        vertical: _r(width, 12, 16),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          ControlButton(icon: Icons.mic_off, label: 'Mute', isActive: false),
          ControlButton(
            icon: Icons.videocam_off,
            label: 'Stop Video',
            isActive: false,
          ),
          ControlButton(
            icon: Icons.screen_share,
            label: 'Share',
            isActive: true,
          ),
          ControlButton(
            icon: Icons.people,
            label: 'Participants',
            isActive: false,
          ),
          ControlButton(icon: Icons.call_end, label: 'Leave', isActive: false),
        ],
      ),
    );
  }
}
