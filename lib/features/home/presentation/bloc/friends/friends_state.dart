part of 'friends_bloc.dart';

sealed class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

final class FriendsInitial extends FriendsState {}

final class FriendsLoading extends FriendsState {}

final class FriendsLoaded extends FriendsState {
  final List<Friend> friends;

  const FriendsLoaded(this.friends);

  @override
  List<Object> get props => [friends];
}

class FriendSuccessState extends FriendsState {
  final String message;
  const FriendSuccessState(this.message);
}

final class FriendsError extends FriendsState {
  final String message;

  const FriendsError(this.message);
}
