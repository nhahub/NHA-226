import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class MeetingController {
  late RtcEngine engine;
  final String appId = 'f44d864260b5421c9281f6833bfe7db7';
  final String channelName = 'Test';
  final int uid = 0;

  List<int> remoteUsers = [];

  Future<void> initEngine() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, remoteUid, elapsed) {
          remoteUsers.add(remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          remoteUsers.remove(remoteUid);
        },
      ),
    );
  }

  Future<void> joinChannel() async {
    await engine.joinChannel(
      token: 'TempToken',
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    remoteUsers.clear();
  }

  Future<void> toggleMic(bool enabled) async {
    await engine.muteLocalAudioStream(!enabled);
  }

  Future<void> toggleCamera(bool enabled) async {
    await engine.enableLocalVideo(enabled);
  }
}
