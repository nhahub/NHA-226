abstract class CallState {}

class CallInitial extends CallState {}

class CallOutgoing extends CallState {
  final String channel;
  final String calleeId;
  CallOutgoing({required this.channel, required this.calleeId});
}

class CallRinging extends CallState {
  final String callerId;
  final String channel;
  final String token;
  CallRinging({required this.callerId, required this.channel, required this.token});
}

class CallInProgress extends CallState {
  final String channel;
  CallInProgress({required this.channel});
}

class CallEnded extends CallState {}
