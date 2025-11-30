part of 'last_calls_bloc.dart';

sealed class LastCallsState extends Equatable {
  const LastCallsState();
  
  @override
  List<Object> get props => [];
}

final class LastCallsInitial extends LastCallsState {}

final class LastCallsLoading extends LastCallsState {}

final class LastCallsLoaded extends LastCallsState {
  final List<Friend> lastCalls;

  const LastCallsLoaded(this.lastCalls);
}

final class LastCallsError extends LastCallsState {
  final String message;

  const LastCallsError(this.message);
}
