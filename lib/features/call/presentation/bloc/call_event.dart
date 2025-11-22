abstract class CallEvent {}

class StartOutgoingCall extends CallEvent {
  final String callerId;
  final String calleeId;
  final String channel;
  final String token;
  
  StartOutgoingCall({
    required this.callerId,
    required this.calleeId,
    required this.channel,
    required this.token,
  });
}

class IncomingCallEvent extends CallEvent {
  final Map<String, dynamic> data;
  IncomingCallEvent(this.data);
}

class AcceptCallEvent extends CallEvent {
  final Map<String, dynamic> data;
  AcceptCallEvent(this.data);
}

class DeclineCallEvent extends CallEvent {}

class EndCallEvent extends CallEvent {}
