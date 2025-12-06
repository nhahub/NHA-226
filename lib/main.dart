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
import 'package:lingo_sign/features/recording_video/data/recording_video_repository_impl.dart';
import 'package:lingo_sign/features/recording_video/data/video_service.dart';
import 'package:lingo_sign/features/recording_video/presentation/cubit/recording_video_cubit.dart';
import 'package:lingo_sign/features/transelation/data/translation_repository_impl.dart';
import 'package:lingo_sign/features/transelation/presentation/cubit/translation/translation_cubit.dart';
import 'package:lingo_sign/features/transelation/presentation/cubit/upload/upload_cubit.dart';
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

// Define CallAction and CallActionType for handling call events
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

final callActionController = StreamController<CallAction>.broadcast();

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
        _handleVoipTokenUpdate(event.body);
        break;
      default:
    }
  });
  runApp(MyApp(appRouter: AppRouter()));
}

void _handleVoipTokenUpdate(Map<String, dynamic>? body) {
  if (body == null) return;
  final token = body['token'] as String?;
  if (token != null) {
    // ignore: avoid_print
    print('VOIP Token updated: $token');
    // Send this token to your backend for push notifications
  }
}

void _handleCallAccept(Map<String, dynamic>? body) {
  if (body == null) return;

  final callId = body['id'] as String?;
  final extra = body['extra'] as Map<String, dynamic>?;
  final isVideoCall = extra?['isVideoCall'] as bool? ?? true;

  if (callId != null) {
    // ignore: avoid_print
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
    // ignore: avoid_print
    print('Call declined with ID: $callId');
    callActionController.add(
      CallAction(callId: callId, type: CallActionType.decline),
    );
  }

  try {
    await FlutterCallkitIncoming.endAllCalls();
  } catch (e) {
    print('Error ending calls: $e');
  }
}

void _handleCallEnded(Map<String, dynamic>? body) async {
  if (body == null) return;

  final callId = body['id'] as String?;

  if (callId != null) {
    // ignore: avoid_print
    print('Call ended with ID: $callId');
    callActionController.add(
      CallAction(callId: callId, type: CallActionType.end),
    );
  }

  try {
    await FlutterCallkitIncoming.endAllCalls();
  } catch (e) {
    print('Error ending calls: $e');
  }
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
          //Recording Video
          BlocProvider(
            create: (_) => RecordingVideoCubit(
              RecordingVideoRepositoryImpl(VideoService()),
            ),
          ),
          //Translation
          BlocProvider(
            create: (_) => TranslationCubit(TranslationRepositoryImpl()),
          ),
          // Upload Video
          BlocProvider(create: (_) => UploadCubit(TranslationRepositoryImpl())),
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
                            // ignore: avoid_print
                            print(
                              '[BLocListener] State changed: ${state.runtimeType}',
                            );

                            if (state is CallMade) {
                              // ignore: avoid_print
                              print(
                                '[BLocListener] CallMade state - navigating to video call',
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VideoCallScreen(
                                    callID: state.call.callId,
                                    isVideoCall: state.call.isVideoCall,
                                  ),
                                ),
                              );
                            } else if (state is CallAccepted) {
                              // Navigate to video call screen after accepting
                              // ignore: avoid_print
                              print(
                                '[BLocListener] CallAccepted state - navigating to video call',
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!context.mounted) return;
                                // ignore: avoid_print
                                print(
                                  '[BLocListener] CallAccepted callback - attempting navigation',
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VideoCallScreen(
                                      callID: state.callId,
                                      isVideoCall: state.isVideoCall,
                                    ),
                                  ),
                                );
                              });
                            } else if (state is CallIncoming) {
                              // ignore: avoid_print
                              print(
                                '[BLocListener] CallIncoming state - showing incoming call',
                              );
                              showIncomingCall(
                                state.callData.callId,
                                state.callData.callerName,
                              );
                            } else if (state is CallError) {
                              // ignore: avoid_print
                              print(
                                '[BLocListener] CallError state: ${state.message}',
                              );
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
    // ignore: avoid_print
    print(
      '[CallActionListener._handleAccept] Handling accept for call: ${action.callId}',
    );

    if (!context.mounted) {
      // ignore: avoid_print
      print('[CallActionListener._handleAccept] Context not mounted, aborting');
      return;
    }

    // ignore: avoid_print
    print(
      '[CallActionListener._handleAccept] Context mounted, attempting to read CallBloc',
    );

    try {
      final callBloc = context.read<CallBloc>();
      // ignore: avoid_print
      print('[CallActionListener._handleAccept] CallBloc read successfully');

      // Update CallBloc to accept call (Firestore update happens here)
      // The BLocListener in MyApp will handle navigation after state update
      callBloc.add(AcceptCallEvent(callId: action.callId));

      // ignore: avoid_print
      print(
        '[CallActionListener._handleAccept] AcceptCallEvent added to CallBloc',
      );
    } catch (e) {
      // ignore: avoid_print
      print(
        '[CallActionListener._handleAccept] Error reading CallBloc or adding event: $e',
      );
    }
  }

  void _handleDecline(CallAction action) {
    // ignore: avoid_print
    print('Handling decline for call: ${action.callId}');
    if (!context.mounted) return;
    context.read<CallBloc>().add(DeclineCallEvent(callId: action.callId));
  }

  void _handleEnd(CallAction action) {
    // ignore: avoid_print
    print('Handling end for call: ${action.callId}');
    if (!context.mounted) return;
    // Close video call screen if open
    Navigator.of(context, rootNavigator: true).pop();
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
