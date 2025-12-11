part of 'call_bloc.dart';

sealed class CallEvent extends Equatable {
  const CallEvent();
  @override
  List<Object> get props => [];
}

class MakeCallEvent extends CallEvent {
  final String receiverId;
  final bool? isVideoCall;
  const MakeCallEvent({required this.receiverId, this.isVideoCall});
  @override
  List<Object> get props => [receiverId, isVideoCall ?? true];
}

class JoinCallEvent extends CallEvent {
  final String callId;
  const JoinCallEvent({required this.callId});
  @override
  List<Object> get props => [callId];
}

class EndCallEvent extends CallEvent {
  final String callId;
  const EndCallEvent({required this.callId});
  @override
  List<Object> get props => [callId];
}
