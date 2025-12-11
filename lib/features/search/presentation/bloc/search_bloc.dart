import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/search/data/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repo;
  bool showAllRecent = true;

  SearchBloc(this.repo) : super(SearchInitialState()) {
    on<SearchTextChangedEvent>(_onTextChanged);
    on<FriendClickedEvent>(_onFriendClicked);
    on<LoadRecentFriendsEvent>(_onLoadRecentFriends);
  }

  Future<void> _onTextChanged(
    SearchTextChangedEvent e,
    Emitter<SearchState> emit,
  ) async {
    if (e.query.isEmpty) {
      add(LoadRecentFriendsEvent());
      return;
    }

    emit(SearchLoadingState());

    try {
      final friends = await repo.search(e.query);

      if (friends.isEmpty) {
        emit(SearchEmptyState('No friends found'));
      } else {
        emit(SearchLoadedState(friends));
      }
    } catch (error) {
      emit(SearchEmptyState('Search failed: $error'));
    }
  }

  Future<void> _onFriendClicked(
    FriendClickedEvent e,
    Emitter<SearchState> emit,
  ) async {
    await repo.saveFriend(e.friend);
  }

  Future<void> _onLoadRecentFriends(
    LoadRecentFriendsEvent e,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoadingState());

    try {
      final friends = await repo.getRecent();

      if (friends.isEmpty) {
        emit(SearchEmptyState('No recent friends yet.'));
        return;
      }

      showAllRecent = !showAllRecent;

      final shownList = showAllRecent ? friends : friends.take(4).toList();

      emit(SearchLoadedState(shownList, showAll: showAllRecent));
    } catch (error) {
      emit(SearchEmptyState('Error loading recent friends: $error'));
    }
  }
}
