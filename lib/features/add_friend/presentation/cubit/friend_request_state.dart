part of 'friend_request_cubit.dart';

abstract class FriendRequestState {}

class FriendRequestInitial extends FriendRequestState {}

class FriendRequestLoading extends FriendRequestState {}

class FriendRequestSuccess extends FriendRequestState {}

class FriendRequestError extends FriendRequestState {
  String? message;
  FriendRequestError(this.message);
}
