import 'package:equatable/equatable.dart';

enum CallEntityType { pending, accepted, declined, completed }

CallEntityType callEntityTypeFromJson(dynamic value) {
  if (value == null) return CallEntityType.pending;

  return CallEntityType.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toString().toLowerCase(),
    orElse: () => CallEntityType.pending,
  );
}

class CallEntity extends Equatable {
  final String callId;
  final String callerId;
  final String callerName;
  final String receiverId;
  final String receiverName;
  final DateTime startTime;
  final DateTime? endTime;
  final CallEntityType type; // pending, accepted, declined, completed
  final int duration;
  final bool isVideoCall;

  const CallEntity({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.receiverId,
    required this.receiverName,
    required this.startTime,
    this.endTime,
    required this.type,
    required this.duration,
    required this.isVideoCall,
  });

  @override
  List<Object?> get props => [
    callId,
    callerId,
    callerName,
    receiverId,
    receiverName,
    startTime,
    endTime,
    type,
    duration,
    isVideoCall,
  ];
}
