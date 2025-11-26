import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:lingo_sign/core/const/string.dart';

class CallController {
  late RtcEngine engine;
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
      token: '',
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
