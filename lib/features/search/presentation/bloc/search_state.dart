import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/search/data/model/user_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<UserModel> users;
  final bool showAll;

  const SearchLoadedState(this.users, {this.showAll = false});

  @override
  List<Object?> get props => [users, showAll];
}

class SearchEmptyState extends SearchState {
  final String message;

  const SearchEmptyState(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchRecentState extends SearchState {
  final List<String> recentQueries;

  const SearchRecentState(this.recentQueries);

  @override
  List<Object?> get props => [recentQueries];
}
