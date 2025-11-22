import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;

  AgoraService._internal();

  final RtcEngine _engine = createAgoraRtcEngine();
  bool _isInitialized = false;

  RtcEngine get engine => _engine;

  Future<void> initialize({required String appId}) async {
    if (_isInitialized) return;

    await _engine.initialize(RtcEngineContext(appId: appId));

    await _engine.enableVideo();

    _isInitialized = true;
  }

  Future<void> joinChannel({
    required String token,
    required String channelName,
    required int uid,
  }) async {
    if (!_isInitialized) {
      throw Exception("Agora engine used before initialization");
    }

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }
}
