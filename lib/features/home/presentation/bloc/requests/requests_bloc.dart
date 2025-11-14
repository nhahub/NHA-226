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
    on<GetAllRequests>(onGetAllRequests);
  }

  FutureOr<void> onGetAllRequests(
    GetAllRequests event,
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
}
