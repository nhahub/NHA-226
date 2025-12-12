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
  final String callerId;
  const JoinCallEvent({required this.callerId});
  @override
  List<Object> get props => [callerId];
}

class EndCallEvent extends CallEvent {
  final String callerId;
  final String receiverId;
  const EndCallEvent({required this.callerId, required this.receiverId});
  @override
  List<Object> get props => [callerId, receiverId];
}
