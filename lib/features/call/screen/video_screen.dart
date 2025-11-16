import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:lingo_sign/features/call/agora_service/agora.dart';

class CallScreen extends StatefulWidget {
  final String channelName;

  const CallScreen({super.key, required this.channelName});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? remoteUid;
  late RtcEngine engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    engine = AgoraService().engine;
    await AgoraService().init();
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, uid, elapsed) {
          setState(() {
            remoteUid = uid;
          });
        },
        onUserOffline: (connection, uid, reason) {
          setState(() {
            remoteUid = null;
          });
        },
      ),
    );
    await engine.enableVideo();
    await engine.joinChannel(
      token: '${AgoraService.token}',
      channelId: widget.channelName,
      uid: 0,
      options: ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    engine.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: remoteUid == null
                ? Text(
                    "Waiting for user...",
                    style: TextStyle(color: Colors.white),
                  )
                : AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: engine,
                      canvas: VideoCanvas(uid: remoteUid),
                      connection: RtcConnection(channelId: widget.channelName),
                    ),
                  ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: SizedBox(
              width: 120,
              height: 160,
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(Icons.call_end),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
