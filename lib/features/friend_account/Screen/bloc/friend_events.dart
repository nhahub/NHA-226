abstract class FriendEvent {}

class AddToFavouriteEvent extends FriendEvent {
  final String friendUid;
  AddToFavouriteEvent(this.friendUid);
}

class RemoveFromFavouriteEvent extends FriendEvent {
  final String friendUid;
  RemoveFromFavouriteEvent(this.friendUid);
}

class UnfriendEvent extends FriendEvent {
  final String friendUid;
  UnfriendEvent(this.friendUid);
}

class LoadFriendEvent extends FriendEvent {
  final String uid;
  LoadFriendEvent(this.uid);
}
