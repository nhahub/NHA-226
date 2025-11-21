import 'package:lingo_sign/features/home/domain/entities/friend.dart';

abstract class SearchEvent {}

class SearchTextChangedEvent extends SearchEvent {
  final String query;
  SearchTextChangedEvent(this.query);
}

class FriendClickedEvent extends SearchEvent {
  final Friend friend;
  FriendClickedEvent(this.friend);
}

class LoadRecentFriendsEvent extends SearchEvent {}
