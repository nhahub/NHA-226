part of 'home_bloc.dart';

enum HomeStateType {
  friendsState,
  favouritesState,
  lasstCallState,
  requestState,
}

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}
