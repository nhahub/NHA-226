import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/domain/usecases/get_call_history_usecase.dart';
import 'package:lingo_sign/features/call/domain/usecases/make_call_usecase.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final MakeCallUseCase makeCallUseCase;
  final GetCallHistoryUseCase getCallHistoryUseCase;

  CallBloc({
    required this.makeCallUseCase,
    required this.getCallHistoryUseCase,
  }) : super(CallInitial()) {
    on<MakeCallEvent>(_onMakeCall);
    on<GetCallHistoryEvent>(_onGetCallHistory);
    on<AcceptCallEvent>(_onAcceptCall);
    on<DeclineCallEvent>(_onDeclineCall);
  }

  Future<void> _onMakeCall(MakeCallEvent event, Emitter<CallState> emit) async {
    emit(CallLoading());
    final result = await makeCallUseCase(
      receiverId: event.receiverId,
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

