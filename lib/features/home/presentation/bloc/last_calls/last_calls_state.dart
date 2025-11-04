part of 'last_calls_bloc.dart';

sealed class LastCallsState extends Equatable {
  const LastCallsState();
  
  @override
  List<Object> get props => [];
}

final class LastCallsInitial extends LastCallsState {}
