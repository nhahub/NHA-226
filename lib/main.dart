import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/auth/data/auth_repository_impl.dart';
import 'package:lingo_sign/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lingo_sign/features/auth/presentation/screen/login_screen.dart';
import 'package:lingo_sign/features/onboarding/data/local_onboarding_data_source.dart';
import 'package:lingo_sign/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:lingo_sign/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:lingo_sign/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:lingo_sign/main_screen.dart';
import 'package:lingo_sign/firebase_options.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.generateRouter,
        home: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoading || state is OnboardingInitial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is UserIsNew) {
              return const OnboardingScreen();
            } else {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return MainScreen();
                  }
                  return LogInScreen();
                },
              );
            }
          },
        ),
      ),
    );
  }
}
