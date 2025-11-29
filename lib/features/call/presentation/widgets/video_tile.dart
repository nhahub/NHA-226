import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:lingo_sign/features/call/controllers/call_controller.dart';
import 'package:lingo_sign/features/call/domain/participants.dart';

class VideoTile extends StatelessWidget {
  final Participants participant;
  final CallController callController;

  const VideoTile({
    super.key,
    required this.participant,
    required this.callController,
  });

  double _r(double w, double mobile, double desktop) =>
      w < 600 ? mobile : desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final uid = participant.uid;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: participant.isSpeaking
            ? Border.all(color: Colors.blue, width: 3)
            : null,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: callController.engine != null
                ? AgoraVideoView(
                    controller: uid == 0
                        ? VideoViewController(
                            rtcEngine: callController.engine!,
                            canvas: VideoCanvas(uid: 0),
                          )
                        : VideoViewController.remote(
                            rtcEngine: callController.engine!,
                            canvas: VideoCanvas(uid: uid),
                            connection: RtcConnection(
                              channelId: callController.channelName,
                            ),
                          ),
                  )
                : Center(
                    child: Icon(
                      Icons.person,
                      size: _r(width, 40, 60),
                      color: Colors.grey[400],
                    ),
                  ),
          ),
          // Speaker overlay & name
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
                  if (participant.isSpeaking)
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      participant.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: participant.isYou
                            ? FontWeight.bold
                            : FontWeight.normal,
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
                participant.isMuted ? Icons.mic_off : Icons.mic,
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
