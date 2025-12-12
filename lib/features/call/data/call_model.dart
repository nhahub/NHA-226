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
    required super.isVideoCall,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callId: json['callId'] ?? '',
      callerId: json['callerId'] ?? '',
      callerName: json['callerName'] ?? '',
      duration: json['duration'] ?? 0,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      isVideoCall: json['isVideoCall'] ?? false,
      receiverId: json['receiverId'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      type: callEntityTypeFromJson(json['type']),
    );
  }

  CallModel copyWith({
    String? callId,
    String? callerId,
    String? callerName,
    String? receiverId,
    DateTime? startTime,
    DateTime? endTime,
    CallEntityType? type,
    int? duration,
    bool? isVideoCall,
  }) {
    return CallModel(
      callId: callId ?? this.callId,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      receiverId: receiverId ?? this.receiverId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isVideoCall: isVideoCall ?? this.isVideoCall,
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
      'type': type.name,
      'duration': duration,
      'isVideoCall': isVideoCall,
    };
  }
}
