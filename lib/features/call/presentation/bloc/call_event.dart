part of 'call_bloc.dart';

sealed class CallEvent extends Equatable {
  const CallEvent();
  @override
  List<Object> get props => [];
}

class MakeCallEvent extends CallEvent {
  final String receiverId;
  final String receiverName;
  final bool isVideoCall;
  const MakeCallEvent({
    required this.receiverId,
    required this.isVideoCall,
    required this.receiverName,
  });
  @override
  List<Object> get props => [receiverId, receiverName, isVideoCall];
}

class AcceptCallEvent extends CallEvent {
  final String callId;
  const AcceptCallEvent({required this.callId});
  @override
  List<Object> get props => [callId];
}

class DeclineCallEvent extends CallEvent {
  final String callId;
  const DeclineCallEvent({required this.callId});
  @override
  List<Object> get props => [callId];
}

class ListenToIncomingCallsEvent extends CallEvent {
  final String userId;
  const ListenToIncomingCallsEvent({required this.userId});
  @override
  List<Object> get props => [userId];
}
