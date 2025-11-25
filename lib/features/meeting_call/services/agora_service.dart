import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

class AgoraService extends ChangeNotifier {
  late RtcEngine engine;
  RtcEngine get rtcEngine => engine;

  int? localUid;
  List<int> remoteUids = [];

  Future<void> init(String appId) async {
    engine = createAgoraRtcEngine();

    await engine.initialize(RtcEngineContext(appId: appId));

    _setupEventHandlers();
  }

  void _setupEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          localUid = connection.localUid;
          notifyListeners();
          print("Local joined with uid: $localUid");
        },

        onUserJoined: (connection, remoteUid, elapsed) {
          if (!remoteUids.contains(remoteUid)) {
            remoteUids.add(remoteUid);
            notifyListeners();
          }
          print("Remote user joined: $remoteUid");
        },

        onUserOffline: (connection, remoteUid, reason) {
          remoteUids.remove(remoteUid);
          notifyListeners();
          print("Remote user offline: $remoteUid");
        },
      ),
    );
  }

  Future<void> joinChannel(String token, String channelId, int uid) async {
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: token,
      channelId: channelId,
      uid: uid,
      options: ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    remoteUids.clear();
    notifyListeners();
  }

  Future<void> toggleMic(bool enabled) async {
    await engine.enableLocalAudio(enabled);
  }

  Future<void> toggleCamera(bool enabled) async {
    await engine.enableLocalVideo(enabled);
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
  }
}
