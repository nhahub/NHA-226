import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../services/agora_service.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String token;

  const CallScreen({super.key, required this.channelName, required this.token});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AgoraService _agora = AgoraService();
  int? _remoteUid;
  bool _joined = false;

  @override
  void initState() {
    super.initState();
    _startCall();
  }

  Future<void> _startCall() async {
    await _agora.initialize(appId: 'f44d864260b5421c9281f6833bfe7db7');

    await _agora.joinChannel(
      token: widget.token,
      channelName: widget.channelName,
      uid: 0,
    );

    _agora.engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, remoteUid, elapsed) {
          if (!mounted) return;

          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          if (!mounted) return;
          setState(() => _remoteUid = null);
        },
      ),
    );
    if (!mounted) return;
    setState(() => _joined = true);
  }

  @override
  void dispose() {
    _agora.leaveChannel();
    super.dispose();
  }

  Widget _localView() {
    if (!_joined) return const Center(child: CircularProgressIndicator());
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _agora.engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _remoteView() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          connection: RtcConnection(channelId: widget.channelName),
          rtcEngine: _agora.engine,
          canvas: VideoCanvas(uid: _remoteUid),
        ),
      );
    }
    return const Center(child: Text('Waiting for remote user...'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call')),
      body: Column(
        children: [
          Expanded(child: _localView()),
          Expanded(child: _remoteView()),
        ],
      ),
    );
  }
}
