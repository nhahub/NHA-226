import 'package:lingo_sign/features/call/domain/call_entity.dart';

class CallModel extends CallEntity {
  const CallModel({
    required super.callId,
    required super.callerId,
    required super.callerName,
    required super.receiverId,
    required super.startTime,
    super.endTime,
    required super.type,
    required super.duration,
    required super.isVideoCall
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callId: json['callId'] ?? '',
      callerId: json['callerId'] ?? '',
      callerName: json['callerName'] ?? '',
      receiverId: json['receiverId'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : null,
      type: callEntityTypeFromJson(json['status']),
      duration: json['duration'] ?? 0,
      isVideoCall: json['isVideoCall'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'receiverId': receiverId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': type.name,
      'duration': duration,
      'isVideoCall': isVideoCall,
    };
  }
}
