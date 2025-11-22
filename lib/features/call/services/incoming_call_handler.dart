import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class IncomingCallHandler {
  Future<void> handleIncoming(
    Map<String, dynamic> callData,
    BuildContext context,
  ) async {
    final safeData = Map<String, dynamic>.from(callData);

    safeData.forEach((key, value) {
      if (value is Timestamp) {
        safeData[key] =
            value.millisecondsSinceEpoch;
      }
    });

    await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: safeData['callId'],
        nameCaller: safeData['callerName']??'Unknown',
        appName: 'LingoSign',
        avatar: safeData['callerAvatar'],
        handle: safeData['callerId'],
        type: 1,
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        extra: safeData,
      ),
    );
  }
}
