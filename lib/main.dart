import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/config/zego_config.dart';
import 'package:lingo_sign/core/get_it/get_it.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_bloc.dart';
import 'package:lingo_sign/features/call/presentation/screen/video_call_screen.dart';
import 'package:lingo_sign/features/home/presentation/bloc/last_calls/last_calls_bloc.dart';
import 'package:lingo_sign/features/home/presentation/bloc/requests/requests_bloc.dart';
import 'package:lingo_sign/features/notification/data/notification_repository_impl.dart';
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
import 'features/notification/presentation/cubit/notifications_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
  await setupServiceLocator();
  ZegoConfig.init();
  runApp(MyApp(appRouter: AppRouter()));
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

          BlocProvider(
            create: (_) {
              final cubit = NotificationsCubit(NotificationRepositoryImpl());
              cubit.listenToNotificationsRealTime();
              return cubit;
            },
          ),
          //Translation
          BlocProvider(
            create: (_) => TranslationCubit(TranslationRepositoryImpl()),
          ),
          // Upload Video
          BlocProvider(create: (_) => UploadCubit(TranslationRepositoryImpl())),
          // Call
          BlocProvider<CallBloc>(create: (_) => getIt<CallBloc>()),
        ],
        child: MaterialApp(
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
                      return BlocListener<CallBloc, CallState>(
                        listener: (_, state) {
                          if (state is CallMade) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoCallScreen(
                                  callID: state.call.callId,
                                  isVideoCall: state.call.isVideoCall,
                                ),
                              ),
                            );
                          }
                        },
                        child: MainScreen(),
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
}
