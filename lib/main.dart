import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/features/call/data/call_firestore_service.dart';
import 'package:lingo_sign/features/call/data/call_repository.dart';
import 'package:lingo_sign/features/call/presentation/state_managment/call_bloc.dart';
import 'package:lingo_sign/features/call/services/agora_service.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
  await AgoraService().initialize(appId: "f44d864260b5421c9281f6833bfe7db7");
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
          BlocProvider(
            create: (context) =>
                AuthBloc(AuthRepositoryImpl())..add(CheckAuthEvent()),
          ),
          BlocProvider(
            create: (_) => OnboardingCubit(
              OnboardingRepositoryImpl(LocalOnboardingDataSource()),
            )..checkUserStatus(),
          ),
          BlocProvider(
            create: (_) => UserInfoCubit(HomeRepositoryImpl())..getUserInfo(),
          ),
          BlocProvider(
            create: (_) => FriendRequestCubit(RequestFriendRepositoryImpl()),
          ),
          BlocProvider(
            create: (_) =>
                FriendsBloc(HomeRepositoryImpl())..add(GetAllFriend()),
          ),
          BlocProvider(
            create: (_) => CallBloc(
              CallRepository(CallFirestoreService()),
              AgoraService(),
            ),
          ),
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
                      return MainScreen();
                    }
                    if (state is AuthLoading) {
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
