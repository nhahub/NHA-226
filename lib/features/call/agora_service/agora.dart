import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  static const appId = "f44d864260b5421c9281f6833bfe7db7";
  static const token = null;
  static const channel = "test";

  final RtcEngine engine = createAgoraRtcEngine();

  Future<void> init() async {
    await Permission.microphone.request();
    await Permission.camera.request();
    await engine.initialize(RtcEngineContext(appId: appId));
  }

  Future<void> join({required bool video}) async {
    if (video) await engine.enableVideo();
    await engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: ChannelMediaOptions(),
    );
  }

  Future<void> leave() async {
    await engine.leaveChannel();
  }
}
