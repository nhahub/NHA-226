import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/domain/call_repository.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository callRepository;

  CallBloc({required this.callRepository}) : super(CallInitial()) {
    on<MakeCallEvent>(_onMakeCall);
    on<JoinCallEvent>(_onJoinCallEvent);
    on<EndCallEvent>(_onEndCallEvent);
  }

  Future<void> _onMakeCall(MakeCallEvent event, Emitter<CallState> emit) async {
    emit(CallLoading(friendId: event.receiverId));
    final result = await callRepository.makeCall(receiverId: event.receiverId);
    result.fold(
      (failure) => emit(CallError(message: failure.toString())),
      (call) => emit(CallMade(call: call)),
    );
  }

  Future<void> _onJoinCallEvent(
    JoinCallEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      final result = await callRepository.updateCallStatus(
        callId: event.callId,
        status: 'accepted',
      );

      result.fold(
        (failure) {
          emit(
            CallError(message: 'Failed to accept call: ${failure.toString()}'),
          );
        },
        (_) {
          emit(CallAccepted(callId: event.callId, isVideoCall: true));
        },
      );
    } catch (e) {
      emit(CallError(message: e.toString()));
    }
  }

  Future<void> _onEndCallEvent(
    EndCallEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      final result = await callRepository.updateCallStatus(
        callId: event.callId,
        status: 'declined',
      );

      result.fold(
        (failure) {
          emit(
            CallError(message: 'Failed to decline call: ${failure.toString()}'),
          );
        },
        (_) {
          // emit(CallDeclined(callId: event.callId));
        },
      );
    } catch (e) {
      emit(CallError(message: e.toString()));
    }
  }
}
