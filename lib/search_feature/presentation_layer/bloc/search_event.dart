import 'package:lingo_sign/search_feature/data_layer/model/user_model.dart';

abstract class SearchEvent {}

class SearchTextChangedEvent extends SearchEvent {
  final String query;
  SearchTextChangedEvent(this.query);
}

class UserProfileClickedEvent extends SearchEvent {
  final UserModel user;
  UserProfileClickedEvent(this.user);
}

class LoadRecentUsersEvent extends SearchEvent {
  final bool showAll;
  LoadRecentUsersEvent({this.showAll = false});
}
