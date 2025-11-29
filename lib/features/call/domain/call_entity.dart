import 'package:equatable/equatable.dart';

class CallEntity extends Equatable {
  final String callId;
  final String callerId;
  final String callerName;
  final String receiverId;
  final String receiverName;
  final DateTime startTime;
  final DateTime? endTime;
  final String status; // pending, accepted, declined, completed
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
    required this.status,
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
    status,
    duration,
    isVideoCall,
  ];
}
