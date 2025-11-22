import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class IncomingCallHandler {
  Future<void> handleIncoming(
    Map<String, dynamic> callData,
    BuildContext context,
  ) async {
    await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: callData['callId'],
        nameCaller: callData['callerName'],
        appName: 'LingoSign',
        avatar: callData['callerAvatar'],
        handle: callData['callerId'],
        type: 1,
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        extra: callData,
      ),
    );
  }
}
