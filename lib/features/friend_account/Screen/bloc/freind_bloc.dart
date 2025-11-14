import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/friend_account/data/friend_repository.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'friend_events.dart';
import 'friend_states.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendRepository repository;

  FriendBloc(this.repository) : super(FriendInitialState()) {
    on<AddToFavouriteEvent>(_addToFavourite);
    on<RemoveFromFavouriteEvent>(_removeFromFavourite);
    on<UnfriendEvent>(_unfriend);
    on<LoadFriendEvent>((event, emit) async {
      emit(FriendLoadingState());

      await emit.forEach<Friend>(
        repository.getFriendByUid(event.uid),
        onData: (friend) => FriendLoadedState(friend),
        onError: (_, __) => FriendErrorState("Failed to load friend"),
      );
    });
  }

  Future<void> _addToFavourite(AddToFavouriteEvent event, Emitter emit) async {
    try {
      emit(FriendLoadingState());

      await repository.addToFavourite(event.friendUid);

      emit(FriendSuccessState("Added to favourites"));
    } catch (e) {
      emit(FriendErrorState(e.toString()));
    }
  }

  Future<void> _removeFromFavourite(
    RemoveFromFavouriteEvent event,
    Emitter emit,
  ) async {
    try {
      emit(FriendLoadingState());

      await repository.removeFromFavourite(event.friendUid);

      emit(FriendSuccessState("Removed from favourites"));
    } catch (e) {
      emit(FriendErrorState(e.toString()));
    }
  }

  Future<void> _unfriend(UnfriendEvent event, Emitter emit) async {
    try {
      emit(FriendLoadingState());

      await repository.unfriend(event.friendUid);

      emit(FriendSuccessState("Unfriended successfully"));
    } catch (e) {
      emit(FriendErrorState(e.toString()));
    }
  }
}
