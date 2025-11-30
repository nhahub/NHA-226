part of 'last_calls_bloc.dart';

sealed class LastCallsEvent extends Equatable {
  const LastCallsEvent();

  @override
  List<Object> get props => [];
}

final class GetAllLastCalls extends LastCallsEvent {}