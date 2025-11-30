import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/domain/call_repository.dart';
import 'package:lingo_sign/features/call/domain/usecases/get_call_history_usecase.dart';
import 'package:lingo_sign/features/call/domain/usecases/make_call_usecase.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final MakeCallUseCase makeCallUseCase;
  final GetCallHistoryUseCase getCallHistoryUseCase;
  final CallRepository callRepository;
  late final StreamSubscription<CallEntity> _incomingCallSub;

  CallBloc({
    required this.makeCallUseCase,
    required this.getCallHistoryUseCase,
    required this.callRepository,
  }) : super(CallInitial()) {
    on<MakeCallEvent>(_onMakeCall);
    on<GetCallHistoryEvent>(_onGetCallHistory);
    on<AcceptCallEvent>(_onAcceptCall);
    on<DeclineCallEvent>(_onDeclineCall);
    on<IncomingCallReceived>(_onIncomingCallReceived);
    _listenToIncomingCalls();
  }

  void _listenToIncomingCalls() {
    _incomingCallSub = callRepository
        .listenToIncomingCalls(FirebaseAuth.instance.currentUser?.uid ?? '')
        .listen((call) {
          if (call.status == 'pending') {
            add(IncomingCallReceived(call));
          }
        });
  }

  Future<void> _onIncomingCallReceived(
    IncomingCallReceived event,
    Emitter<CallState> emit,
  ) async {
    emit(CallIncoming(callData: event.call));
  }

  @override
  Future<void> close() {
    _incomingCallSub.cancel();
    return super.close();
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

  Future<void> _onGetCallHistory(
    GetCallHistoryEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(CallLoading());
    final result = await getCallHistoryUseCase();
    result.fold(
      (failure) => emit(CallError(message: failure.toString())),
      (calls) => emit(CallHistory(calls: calls)),
    );
  }

  Future<void> _onAcceptCall(
    AcceptCallEvent event,
    Emitter<CallState> emit,
  ) async {
    // Handle accept logic
  }

  Future<void> _onDeclineCall(
    DeclineCallEvent event,
    Emitter<CallState> emit,
  ) async {
    // Handle decline logic
  }
}
