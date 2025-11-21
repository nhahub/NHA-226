import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<Friend> friends;
  final bool showAll;

  const SearchLoadedState(this.friends, {this.showAll = true});

  @override
  List<Object?> get props => [friends, showAll];
}

class SearchEmptyState extends SearchState {
  final String message;

  const SearchEmptyState(this.message);

  @override
  List<Object?> get props => [message];
}
