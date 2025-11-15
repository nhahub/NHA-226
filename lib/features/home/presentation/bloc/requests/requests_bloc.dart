import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/home/domain/entities/request.dart';
import 'package:lingo_sign/features/home/domain/home_repository.dart';

part 'requests_event.dart';
part 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  HomeRepository homeRepository;
  RequestsBloc(this.homeRepository) : super(RequestsInitial()) {
    on<GetAllRequestsEvent>(onGetAllRequests);
    on<AcceptRequestEvent>(onAcceptRequestEvent);
    on<RejectRequestEvent>(onRejectRequestEvent);
  }

  FutureOr<void> onGetAllRequests(
    GetAllRequestsEvent event,
    Emitter<RequestsState> emit,
  ) async {
    emit(RequestsLoading());
    try {
      final requests = await homeRepository.getRequstes();
      emit(RequestsLoaded(requests));
    } catch (e) {
      emit(RequestsError(e.toString()));
    }
  }

  FutureOr<void> onAcceptRequestEvent(
    AcceptRequestEvent event,
    Emitter<RequestsState> emit,
  ) async {
    try {
      final isTrue = await homeRepository.acceptFriendRequest(event.uid);
      if (isTrue) {
        emit(SuccessAcceptedRequest(message: 'You’re now friend to Mohamed'));
      }
      add(GetAllRequestsEvent());
    } catch (e) {
      emit(RequestsError(e.toString()));
    }
  }

  FutureOr<void> onRejectRequestEvent(
    RejectRequestEvent event,
    Emitter<RequestsState> emit,
  ) async {
    try {
      final isTrue = await homeRepository.acceptFriendRequest(event.uid);
      if (isTrue) {
        emit(SuccessRejectedRequest(message: 'Ignore friend invitation'));
      }
      add(GetAllRequestsEvent());
    } catch (e) {
      emit(RequestsError(e.toString()));
    }
  }
}
