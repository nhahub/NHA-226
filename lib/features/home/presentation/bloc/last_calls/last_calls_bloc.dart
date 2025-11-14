import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:lingo_sign/features/home/domain/home_repository.dart';

part 'last_calls_event.dart';
part 'last_calls_state.dart';

class LastCallsBloc extends Bloc<LastCallsEvent, LastCallsState> {
  final HomeRepository homeRepository;
  LastCallsBloc(this.homeRepository) : super(LastCallsInitial()) {
    on<GetAllLastCalls>(onGetAllLastCalls);
  }

  FutureOr<void> onGetAllLastCalls(
    GetAllLastCalls event,
    Emitter<LastCallsState> emit,
  ) async {
    emit(LastCallsLoading());
    try {
      final lastCalls = await homeRepository.getLastCalls();
      emit(LastCallsLoaded(lastCalls));
    } catch (e) {
      emit(LastCallsError(e.toString()));
    }
  }
}
