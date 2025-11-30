import 'package:lingo_sign/core/const/string.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoConfig {
  static Future<void> init({String? userId, String? userName}) async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appId,
      appSign: appSign,
      userID: userId ?? 'UserId',
      userName: userName ?? 'UserName',
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
}
