import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/domain/call_repository.dart';
import 'package:lingo_sign/features/call/domain/make_call_usecase.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final MakeCallUseCase makeCallUseCase;
  final CallRepository callRepository;

  CallBloc({
    required this.makeCallUseCase,
    required this.callRepository,
  }) : super(CallInitial()) {
    on<MakeCallEvent>(_onMakeCall);
    on<AcceptCallEvent>(_onAcceptCall);
    on<DeclineCallEvent>(_onDeclineCall);
    on<ListenToIncomingCallsEvent>(_onListenToIncomingCalls);
  }

  Future<void> _onListenToIncomingCalls(
    ListenToIncomingCallsEvent event,
    Emitter<CallState> emit,
  ) async {
    await emit.forEach<CallEntity>(
      callRepository.listenToIncomingCalls(event.userId),
      onData: (call) => CallIncoming(callData: call),
      onError: (e, _) => CallError(message: e.toString()),
    );
  }

  Future<void> _onMakeCall(MakeCallEvent event, Emitter<CallState> emit) async {
    emit(CallLoading());
    final result = await makeCallUseCase(
      receiverId: event.receiverId,
      receiverName: event.receiverName,
      isVideoCall: event.isVideoCall,
    );
    result.fold(
      (failure) => emit(CallError(message: failure.toString())),
      (call) => emit(CallMade(call: call)),
    );
  }

  Future<void> _onAcceptCall(
    AcceptCallEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      // ignore: avoid_print
      print('[CallBloc] _onAcceptCall called with callId: ${event.callId}');

      // ignore: avoid_print
      print('[CallBloc] Updating Firestore call status to accepted');
      final result = await callRepository.updateCallStatus(
        callId: event.callId,
        status: 'accepted',
      );

      // Handle the Either result properly
      result.fold(
        (failure) {
          // ignore: avoid_print
          print('[CallBloc] Firestore update failed: ${failure.toString()}');
          emit(
            CallError(message: 'Failed to accept call: ${failure.toString()}'),
          );
        },
        (_) {
          // ignore: avoid_print
          print(
            '[CallBloc] Firestore update successful, emitting CallAccepted state',
          );

          // Emit CallAccepted state to signal navigation to video call
          // Navigator will use this to go to VideoCallScreen
          emit(CallAccepted(callId: event.callId, isVideoCall: true));

          // ignore: avoid_print
          print('[CallBloc] CallAccepted state emitted successfully');
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print('[CallBloc] Error in _onAcceptCall: $e');
      emit(CallError(message: e.toString()));
    }
  }

  Future<void> _onDeclineCall(
    DeclineCallEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      // ignore: avoid_print
      print('[CallBloc] _onDeclineCall called with callId: ${event.callId}');

      final result = await callRepository.updateCallStatus(
        callId: event.callId,
        status: 'declined',
      );

      result.fold(
        (failure) {
          // ignore: avoid_print
          print(
            '[CallBloc] Firestore decline update failed: ${failure.toString()}',
          );
          emit(
            CallError(message: 'Failed to decline call: ${failure.toString()}'),
          );
        },
        (_) {
          // ignore: avoid_print
          print('[CallBloc] Call declined successfully');
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print('[CallBloc] Error in _onDeclineCall: $e');
      emit(CallError(message: e.toString()));
    }
  }
}
