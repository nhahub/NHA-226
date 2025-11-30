part of 'friends_bloc.dart';

sealed class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

final class GetAllFriend extends FriendsEvent {}

 class AddToFavouriteEvent extends FriendsEvent {
  final String friendUid;
  const AddToFavouriteEvent(this.friendUid);
}

class RemoveFromFavouriteEvent extends FriendsEvent {
  final String friendUid;
  const RemoveFromFavouriteEvent(this.friendUid);
}

class UnfriendEvent extends FriendsEvent {
  final String friendUid;
  const UnfriendEvent(this.friendUid);
}
