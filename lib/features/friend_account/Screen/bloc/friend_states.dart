import 'package:lingo_sign/features/friend_account/Freind.dart';

abstract class FriendState {}

class FriendInitialState extends FriendState {}

class FriendLoadingState extends FriendState {}

class FriendLoadedState extends FriendState {
  final Friend friend;
  FriendLoadedState(this.friend);
}

class FriendSuccessState extends FriendState {
  final String message;
  FriendSuccessState(this.message);
}

class FriendErrorState extends FriendState {
  final String error;
  FriendErrorState(this.error);
}
