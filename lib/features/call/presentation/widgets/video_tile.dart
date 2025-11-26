import 'package:flutter/material.dart';
import 'package:lingo_sign/features/call/domain/participants.dart';

class VideoTile extends StatelessWidget {
  final Participants participants;
  const VideoTile({super.key, required this.participants});

  double _r(double w, double mobile, double desktop) {
    return w < 600 ? mobile : desktop;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: participants.isSpeaking
            ? Border.all(color: Colors.blue, width: 3)
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.person,
              size: _r(width, 40, 60),
              color: Colors.grey[400],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  if (participants.isSpeaking)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                    ),

                  Expanded(
                    child: Text(
                      participants.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _r(width, 14, 16),
                        fontWeight: participants.isYou
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),

                  if (participants.isYou)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'You',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _r(width, 10, 12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic_off,
                color: Colors.white,
                size: _r(width, 16, 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
