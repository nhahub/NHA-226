import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  RtcEngine? _engine;
  bool _initialized = false;

  Future<void> init(String appId) async {
    if (_initialized) return;
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
    await _engine!.enableVideo();
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {},
        onUserJoined: (connection, remoteUid, elapsed) {},
        onUserOffline: (connection, remoteUid, reason) {},
      ),
    );
    _initialized = true;
  }

  RtcEngine get engine {
    if (_engine == null)
      throw Exception('Agora engine used before initialization');
    return _engine!;
  }

  Future<void> joinChannel({
    required String token,
    required String channelName,
    int uid = 0,
  }) async {
    if (!_initialized)
      throw Exception('Agora engine used before initialization');
    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishMicrophoneTrack: true,
        publishCameraTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
    await _engine!.startPreview();
  }

  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    _initialized = false;
  }
}
