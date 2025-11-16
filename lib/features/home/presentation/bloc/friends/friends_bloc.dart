import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:lingo_sign/features/home/domain/home_repository.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final HomeRepository homeRepository;

  FriendsBloc(this.homeRepository) : super(FriendsInitial()) {
    on<GetAllFriend>(onGetAllFriend);
    on<AddToFavouriteEvent>(_addToFavourite);
    on<RemoveFromFavouriteEvent>(_removeFromFavourite);
    on<UnfriendEvent>(_unfriend);
  }
  FutureOr<void> onGetAllFriend(
    GetAllFriend event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading());
    try {
      final freinds = await homeRepository.getFriends();
      emit(FriendsLoaded(freinds));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }

  Future<void> _addToFavourite(AddToFavouriteEvent event, Emitter emit) async {
    try {
      emit(FriendsLoading());

      await homeRepository.addToFavourite(event.friendUid);

      emit(FriendSuccessState("Added to favourites"));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }

  Future<void> _removeFromFavourite(
    RemoveFromFavouriteEvent event,
    Emitter emit,
  ) async {
    try {
      emit(FriendsLoading());

      await homeRepository.removeFromFavourite(event.friendUid);

      emit(FriendSuccessState("Removed from favourites"));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }

  Future<void> _unfriend(UnfriendEvent event, Emitter emit) async {
    try {
      emit(FriendsLoading());

      await homeRepository.unfriend(event.friendUid);

      emit(FriendSuccessState("Unfriended successfully"));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }
}
