import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:lingo_sign/features/call/presentation/screens/call_screen.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_bloc.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_state.dart';
import '../../services/agora_service.dart';
import '../../data/call_repository.dart';
import '../../data/call_firestore_service.dart';

class IncomingHandler extends StatefulWidget {
  const IncomingHandler({super.key, required this.myUserId});
  
  final String myUserId;

  @override
  State<IncomingHandler> createState() => _IncomingHandlerState();
}

class _IncomingHandlerState extends State<IncomingHandler> {
  late CallBloc _callBloc;

  @override
  void initState() {
    super.initState();
    final repo = CallRepository(CallFirestoreService());
    _callBloc = CallBloc(repo, AgoraService());
    _callBloc.startListening(widget.myUserId);
  }

  @override
  void dispose() {
    _callBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _callBloc,
      child: BlocListener<CallBloc, CallState>(
        listener: (context, state) {
          if (state is CallRinging) {
            final params = CallKitParams(
              id: state.channel,
              nameCaller: state.callerId,
              appName: 'LingoSign',
              handle: state.callerId,
              type: 1,
              duration: 30000,
              textAccept: 'Accept',
              textDecline: 'Decline',
              extra: {'channel': state.channel, 'token': ''},
            );
            FlutterCallkitIncoming.showCallkitIncoming(params);
          } else if (state is CallInProgress) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CallScreen(channelName: state.channel),
              ),
            );
          }
        },
        child: Container(),
      ),
    );
  }
}
