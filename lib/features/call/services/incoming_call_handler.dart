// import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class IncomingCallHandler {
//   Future<void> handleIncoming(
//     Map<String, dynamic> callData,
//     BuildContext context,
//   ) async {

//     // تنظيف callData من أي Timestamp
//     Map<String, dynamic> cleanCallData = {};
//     callData.forEach((key, value) {
//       if (value is Timestamp) {
//         cleanCallData[key] = value.toDate().toIso8601String();
//       } else {
//         cleanCallData[key] = value;
//       }
//     });

//     await FlutterCallkitIncoming.showCallkitIncoming(
//       CallKitParams(
//         id: callData['callId'],
//         nameCaller: callData['callerName'],
//         appName: 'LingoSign',
//         avatar: callData['callerAvatar'],
//         handle: callData['callerId'],
//         type: 1,
//         duration: 30000,
//         textAccept: 'Accept',
//         textDecline: 'Decline',
//         extra: cleanCallData,
//       ),
//     );
//   }
// }
