part of 'call_bloc.dart';

sealed class CallState extends Equatable {
  const CallState();
  
  @override
  List<Object> get props => [];
}

class CallInitial extends CallState {
  @override
  List<Object> get props => [];
}

class CallLoading extends CallState {
  @override
  List<Object> get props => [];
}

class CallMade extends CallState {
  final CallEntity call;
  const CallMade({required this.call});
  @override
  List<Object> get props => [call];
}

class CallIncoming extends CallState {
  final CallEntity callData;
  const CallIncoming({required this.callData});
  @override
  List<Object> get props => [callData];
}

class CallHistory extends CallState {
  final List<CallEntity> calls;
  const CallHistory({required this.calls});
  @override
  List<Object> get props => [calls];
}

class CallError extends CallState {
  final String message;
  const CallError({required this.message});
  @override
  List<Object> get props => [message];
}
