import 'package:flutter/material.dart';
import 'package:lingo_sign/features/call/presentation/widgets/conrtol_button.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({super.key, required this.endCall});

  final Future<void> Function() endCall;

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
        children: [
          ControlButton(icon: Icons.mic_off, isActive: false),
          ControlButton(icon: Icons.videocam_off, isActive: false),
          ControlButton(icon: Icons.flip_camera_ios_rounded, isActive: false),
          ControlButton(icon: Icons.call_end, label: 'Leave', isActive: false),
        ],
      ),
    );
  }
}
