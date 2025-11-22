import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  static const String appId = "af731e89861e43d49b2339823b880d08";
  static const String channel = "mero";

  int? remoteUid;
  bool localUserJoined = false;
  late RtcEngine agoraEngine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // ask for permissions.
    await [Permission.camera, Permission.microphone].request();

    // create agora engine.
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log("Joined channel: ${connection.channelId}");
          setState(() => localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          log("Remote user $uid joined");
          setState(() => remoteUid = uid);
        },
        onUserOffline: (RtcConnection connection, int uid, reason) {
          log("Remote user $uid left");
          setState(() => remoteUid = null);
        },
      ),
    );

    await agoraEngine.enableVideo();
    await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await agoraEngine.startPreview();

    final int myUid = DateTime.now().millisecondsSinceEpoch % 100000;

    await agoraEngine.joinChannel(
      token: '',
      channelId: channel,
      uid: myUid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  @override
  void dispose() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  Widget _localPreview() {
    if (localUserJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Initializing...", style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }
  }

  Widget _remoteVideo() {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: channel),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "Waiting for remote user...",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agora Video Call"),
        backgroundColor: Colors.blue[700],
      ),
      body: Stack(
        children: [
          // Remote video (full screen)
          Positioned.fill(child: _remoteVideo()),

          // Local preview (picture-in-picture)
          Positioned(
            bottom: 16,
            right: 16,
            width: 120,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _localPreview(),
            ),
          ),

          // Status indicator
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                remoteUid != null ? "Connected" : "Waiting...",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),

      // End call button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          agoraEngine.leaveChannel();
          Navigator.pop(context);
        },
        child: const Icon(Icons.call_end),
      ),
    );
  }
}
