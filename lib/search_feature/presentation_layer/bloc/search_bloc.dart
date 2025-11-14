import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/search_feature/data_layer/repositories/search_repository.dart';
import 'package:lingo_sign/search_feature/presentation_layer/bloc/search_event.dart';
import 'package:lingo_sign/search_feature/presentation_layer/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repo;

  bool showAllRecent = true;

  SearchBloc(this.repo) : super(SearchInitialState()) {
    on<SearchTextChangedEvent>(_onTextChanged);
    on<UserProfileClickedEvent>(_onUserClicked);
    on<LoadRecentUsersEvent>(_onLoadRecentUsers);
  }

  Future<void> _onTextChanged(
    SearchTextChangedEvent e,
    Emitter<SearchState> emit,
  ) async {
    if (e.query.isEmpty) {
      add(LoadRecentUsersEvent());
      return;
    }

    emit(SearchLoadingState());

    final users = await repo.search(e.query);
    if (users.isEmpty) {
      emit(SearchEmptyState('No users found'));
    } else {
      emit(SearchLoadedState(users));
    }
  }

  Future<void> _onUserClicked(
    UserProfileClickedEvent e,
    Emitter<SearchState> emit,
  ) async {
    await repo.saveUser(e.user);
  }

  Future<void> _onLoadRecentUsers(
    LoadRecentUsersEvent e,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoadingState());

    try {
      final users = await repo.getRecent();

      if (users.isEmpty) {
        emit(SearchEmptyState('No recent searches yet.'));
        return;
      }
      showAllRecent = !showAllRecent;
      final shownList = showAllRecent ? users : users.take(4).toList();
      emit(SearchLoadedState(shownList, showAll: showAllRecent));
    } catch (error) {
      emit(SearchEmptyState('Error loading recent users: $error'));
    }
  }
}
