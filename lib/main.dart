import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/config/zego_config.dart';
import 'package:lingo_sign/core/get_it/get_it.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_bloc.dart';
import 'package:lingo_sign/features/call/presentation/screen/video_call_screen.dart';
import 'package:lingo_sign/features/home/presentation/bloc/last_calls/last_calls_bloc.dart';
import 'package:lingo_sign/features/home/presentation/bloc/requests/requests_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:lingo_sign/core/const/string.dart';
import 'package:lingo_sign/core/screen/loading_screen.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/add_friend/data/request_friend_repository_impl.dart';
import 'package:lingo_sign/features/add_friend/presentation/cubit/friend_request_cubit.dart';
import 'package:lingo_sign/features/auth/data/auth_repository_impl.dart';
import 'package:lingo_sign/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lingo_sign/features/auth/presentation/screen/login_screen.dart';
import 'package:lingo_sign/features/home/data/home_repository_impl.dart';
import 'package:lingo_sign/features/home/presentation/bloc/friends/friends_bloc.dart';
import 'package:lingo_sign/features/home/presentation/bloc/user_info/user_info_cubit.dart';
import 'package:lingo_sign/features/onboarding/data/local_onboarding_data_source.dart';
import 'package:lingo_sign/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:lingo_sign/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:lingo_sign/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:lingo_sign/firebase_options.dart';
import 'package:lingo_sign/main_screen.dart';
import 'app_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Stream controller to handle call actions
final callActionController = StreamController<CallAction>.broadcast();

class CallAction {
  final String callId;
  final CallActionType type;
  final bool isVideoCall;

  CallAction({
    required this.callId,
    required this.type,
    this.isVideoCall = true,
  });
}

enum CallActionType { accept, decline, end }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
  await setupServiceLocator();
  ZegoConfig.init();
  FlutterCallkitIncoming.onEvent.listen((event) {
    switch (event!.event) {
      case Event.actionCallAccept:
        _handleCallAccept(event.body);
        break;
      case Event.actionCallDecline:
        _handleCallDecline(event.body);
        break;
      case Event.actionCallEnded:
        _handleCallEnded(event.body);
        break;
      case Event.actionDidUpdateDevicePushTokenVoip:
        break;
      default:
    }
  });
  runApp(MyApp(appRouter: AppRouter()));
}

void _handleCallAccept(Map<String, dynamic>? body) async {
  if (body == null) return;

  final callId = body['id'] as String?;
  final extra = body['extra'] as Map<String, dynamic>?;
  final isVideoCall = extra?['isVideoCall'] as bool? ?? true;

  if (callId != null) {
    print('Call accepted with ID: $callId');
    callActionController.add(
      CallAction(
        callId: callId,
        type: CallActionType.accept,
        isVideoCall: isVideoCall,
      ),
    );
  }
}

void _handleCallDecline(Map<String, dynamic>? body) async {
  if (body == null) return;

  final callId = body['id'] as String?;

  if (callId != null) {
    print('Call declined with ID: $callId');
    callActionController.add(
      CallAction(callId: callId, type: CallActionType.decline),
    );
  }

  await FlutterCallkitIncoming.endAllCalls();
}

void _handleCallEnded(Map<String, dynamic>? body) async {
  if (body == null) return;

  final callId = body['id'] as String?;

  if (callId != null) {
    print('Call ended with ID: $callId');
    callActionController.add(
      CallAction(callId: callId, type: CallActionType.end),
    );
  }

  await FlutterCallkitIncoming.endAllCalls();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(context.width, context.height),
      builder: (_, child) => MultiBlocProvider(
        providers: [
          // Auth
          BlocProvider(
            create: (context) =>
                AuthBloc(AuthRepositoryImpl())..add(CheckAuthEvent()),
          ),
          // Onboarding
          BlocProvider(
            create: (_) => OnboardingCubit(
              OnboardingRepositoryImpl(LocalOnboardingDataSource()),
            )..checkUserStatus(),
          ),
          // User Information
          BlocProvider(
            create: (_) => UserInfoCubit(HomeRepositoryImpl())..getUserInfo(),
          ),
          // Friend Request
          BlocProvider(
            create: (_) => FriendRequestCubit(RequestFriendRepositoryImpl()),
          ),
          // Friends
          BlocProvider(
            create: (_) =>
                FriendsBloc(HomeRepositoryImpl())..add(GetAllFriend()),
          ),
          // Last Calls
          BlocProvider(
            create: (_) =>
                LastCallsBloc(HomeRepositoryImpl())..add(GetAllLastCalls()),
          ),
          // Requests
          BlocProvider(
            create: (_) =>
                RequestsBloc(HomeRepositoryImpl())..add(GetAllRequestsEvent()),
          ),
          // Call
          BlocProvider<CallBloc>(create: (_) => sl<CallBloc>()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRouter,
          home: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingLoading || state is OnboardingInitial) {
                return const LoadingScreen();
              }
              if (state is UserIsNew) {
                return const OnboardingScreen();
              } else {
                return BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return CallActionListener(
                        child: BlocListener<CallBloc, CallState>(
                          listener: (context, state) {
                            if (state is CallMade) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VideoCallScreen(
                                      callID: state.call.callId,
                                      isVideoCall: state.call.isVideoCall,
                                    ),
                                  ),
                                );
                              });
                            } else if (state is CallIncoming) {
                              showIncomingCall(
                                state.callData.callId,
                                state.callData.callerName,
                              );
                            } else if (state is CallError) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              });
                            }
                          },
                          child: MainScreen(),
                        ),
                      );
                    }
                    if (state is AuthLoading || state is AuthInitial) {
                      return LoadingScreen();
                    }
                    return LogInScreen();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void showIncomingCall(
    String callId,
    String callerName, {
    bool isVideoCall = true,
  }) async {
    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'Lingo Sign',
      avatar: 'https://link-to-avatar.png',
      handle: 'username',
      type: isVideoCall ? 1 : 0,
      duration: 30000,
      textAccept: 'Answer',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(showNotification: true),
      extra: <String, dynamic>{'callId': callId, 'isVideoCall': isVideoCall},
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}

// Widget to listen to call actions
class CallActionListener extends StatefulWidget {
  final Widget child;

  const CallActionListener({super.key, required this.child});

  @override
  State<CallActionListener> createState() => _CallActionListenerState();
}

class _CallActionListenerState extends State<CallActionListener> {
  StreamSubscription<CallAction>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = callActionController.stream.listen((action) {
      if (!mounted) return;

      switch (action.type) {
        case CallActionType.accept:
          _handleAccept(action);
          break;
        case CallActionType.decline:
          _handleDecline(action);
          break;
        case CallActionType.end:
          _handleEnd(action);
          break;
      }
    });
  }

  void _handleAccept(CallAction action) {
    print('Handling accept for call: ${action.callId}');

    // Add event to CallBloc
    context.read<CallBloc>().add(AcceptCallEvent(callId: action.callId));

    // Navigate to video call screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          callID: action.callId,
          isVideoCall: action.isVideoCall,
        ),
      ),
    );
  }

  void _handleDecline(CallAction action) {
    print('Handling decline for call: ${action.callId}');
    context.read<CallBloc>().add(DeclineCallEvent(callId: action.callId));
  }

  void _handleEnd(CallAction action) {
    print('Handling end for call: ${action.callId}');
    // You can add an EndCallEvent here if needed
    // context.read<CallBloc>().add(EndCallEvent(callId: action.callId));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
