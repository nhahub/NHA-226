import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/screen/loading_screen.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/add_friend/data/request_friend_repository_impl.dart';
import 'package:lingo_sign/features/add_friend/presentation/cubit/friend_request_cubit.dart';
import 'package:lingo_sign/features/auth/data/auth_repository_impl.dart';
import 'package:lingo_sign/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lingo_sign/features/auth/presentation/screen/login_screen.dart';
import 'package:lingo_sign/features/home/data/home_repository_impl.dart';
import 'package:lingo_sign/features/home/presentation/bloc/user_info/user_info_cubit.dart';
import 'package:lingo_sign/features/onboarding/data/local_onboarding_data_source.dart';
import 'package:lingo_sign/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:lingo_sign/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:lingo_sign/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:lingo_sign/features/profile/data/model/repositries/profile_repositry.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_event.dart';
import 'package:lingo_sign/main_screen.dart';
import 'package:lingo_sign/firebase_options.dart';
import 'app_router.dart';
import 'package:lingo_sign/features/profile/controller/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/screen/profile_screen.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final SettingsController settingsController = SettingsController();

  Future<void> initializeNotifications() async {
    await settingsController.initializeLocalNotifications();
  }

  await Supabase.initialize(
    url: "https://idfzqftyfepzfypxwmst.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkZnpxZnR5ZmVwemZ5cHh3bXN0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIxODcwNTYsImV4cCI6MjA3Nzc2MzA1Nn0.ZfK-hPdoQ3S_Wxr7zNzjKRdHX7Kdq8MXmKZudHoI7Pc",
  );

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false;

  runApp(MyApp(
    appRouter: AppRouter(),
    isDarkMode: isDarkMode,
  ));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  final bool isDarkMode;

  const MyApp({
    super.key,
    required this.appRouter,
    required this.isDarkMode,
  });

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    requestNotificationPermission();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from notification: ${message.messageId}");
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("App launched from terminated state by notification");
      }
    });
  }

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      sound: true,
      criticalAlert: false,
      provisional: false,
      badge: true,
    );

    print("PERMISSION STATUS >>> ${settings.authorizationStatus}");
  }

  void updateTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    setState(() => _isDarkMode = isDark);
  }

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
      create: (context) => ProfileBloc(
        profileRepository: ProfileRepository(),
      )..add(LoadUserProfile()), 
    ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: widget.appRouter.generateRouter,
          themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: Colors.white,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: Colors.black,
          ),
          
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

