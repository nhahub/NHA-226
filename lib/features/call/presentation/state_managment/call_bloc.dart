import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:lingo_sign/features/call/data/call_repository.dart';
import 'package:lingo_sign/features/call/services/agora_service.dart';
import 'call_event.dart';
import 'call_state.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository repo;
  final AgoraService agora;
  StreamSubscription<Map<String, dynamic>?>? _sub;

  CallBloc(this.repo, this.agora) : super(CallInitial()) {
    on<StartOutgoingCall>(_onStartOutgoingCall);
    on<IncomingCallEvent>(_onIncomingCall);
    on<AcceptCallEvent>(_onAcceptCall);
    on<DeclineCallEvent>(_onDeclineCall);
    on<EndCallEvent>(_onEndCall);
  }

  Future<void> _onStartOutgoingCall(StartOutgoingCall e, Emitter emit) async {
    emit(CallOutgoing(channel: e.channel, calleeId: e.calleeId));
    await repo.startCall(
      callerId: e.callerId,
      receiverId: e.calleeId,
      channelName: e.channel,
      token: e.token,
    );
  }

  Future<void> _onIncomingCall(IncomingCallEvent e, Emitter emit) async {
    final data = e.data;
    emit(
      CallRinging(
        callerId: data['callerId'],
        channel: data['channelName'],
        token: data['token'],
      ),
    );
    final params = <String, dynamic>{
      'id': data['channelName'],
      'nameCaller': data['callerId'],
      'appName': 'LingoSign',
      'handle': data['callerId'],
      'type': 0,
      'duration': 30000,
      'textAccept': 'Accept',
      'textDecline': 'Decline',
      'extra': {'channel': data['channelName'], 'token': data['token']},
    };
    FlutterCallkitIncoming.showCallkitIncoming(params as CallKitParams);
  }

  Future<void> _onAcceptCall(AcceptCallEvent e, Emitter emit) async {
    final data = e.data;

    await repo.acceptCall(receiverId: data['callerId']);

    final appId = 'f44d864260b5421c9281f6833bfe7db7';
    await agora.initialize(appId: appId);

    await agora.joinChannel(
      token: data['token'],
      channelName: data['channelName'],
      uid: data['uid'] ?? 0,
    );

    emit(CallInProgress(channel: data['channelName']));

    FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> _onDeclineCall(DeclineCallEvent e, Emitter emit) async {
    emit(CallEnded());
    FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> _onEndCall(EndCallEvent e, Emitter emit) async {
    await agora.leaveChannel();
    emit(CallEnded());
  }

  void startListening(String myUserId) {
    _sub?.cancel();
    _sub = repo.incomingStream(myUserId).listen((data) {
      if (data == null) return;
      add(IncomingCallEvent(data));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
