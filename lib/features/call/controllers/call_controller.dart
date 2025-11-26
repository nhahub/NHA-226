import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/string.dart';
import 'package:permission_handler/permission_handler.dart';

class CallController extends ChangeNotifier {
  RtcEngine? engine;
  final String channelName = 'Test';
  final List<int> users = [0]; // local user

  bool isInitialized = false;

  Future<void> initEngine() async {
    // request permissions
    await [Permission.camera, Permission.microphone].request();

    engine = createAgoraRtcEngine();
    await engine!.initialize(RtcEngineContext(appId: appId));

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection conn, int uid) {
          isInitialized = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection conn, int uid, int elapsed) {
          if (!users.contains(uid)) users.add(uid);
          notifyListeners();
        },
        onUserOffline: (RtcConnection conn, int uid, UserOfflineReasonType reason) {
          users.remove(uid);
          notifyListeners();
        },
      ),
    );

    await engine!.enableVideo();
    await engine!.startPreview();

    await joinChannel();
  }

  Future<void> joinChannel() async {
    if (engine == null) return;

    await engine!.joinChannel(
      token: '',
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
      ),
    );
  }

  Future<void> leaveChannel() async {
    if (engine == null) return;

    await engine!.leaveChannel();
    await engine!.release();
    engine = null;
    users.clear();
    isInitialized = false;
    notifyListeners();
  }

  Future<void> toggleMic(bool enabled) async {
    if (engine == null) return;
    await engine!.muteLocalAudioStream(!enabled);
  }

  Future<void> toggleCamera(bool enabled) async {
    if (engine == null) return;
    await engine!.enableLocalVideo(enabled);
  }
}