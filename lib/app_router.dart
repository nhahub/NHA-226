import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/account_info_page/data/account_repository.dart';
import 'package:lingo_sign/features/account_info_page/presentation/bloc/edit_account_info_bloc.dart';
import 'package:lingo_sign/features/account_info_page/presentation/screens/account_info_screen.dart';
import 'package:lingo_sign/features/auth/presentation/screen/forgot_password_screen.dart';
import 'package:lingo_sign/features/auth/presentation/screen/login_screen.dart';
import 'package:lingo_sign/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:lingo_sign/features/notification/data/notification_repository_impl.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_cubit.dart';
import 'package:lingo_sign/features/notification/presentation/screen/notification_screen.dart';
import 'package:lingo_sign/features/search/data/search_repository.dart';
import 'package:lingo_sign/features/search/presentation/bloc/search_bloc.dart';
import 'package:lingo_sign/features/search/presentation/screens/search_screen.dart';
import 'package:lingo_sign/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  Route? generateRouter(RouteSettings setting) {
    switch (setting.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LogInScreen());
      case signupScreen:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case forgetPasswordScreen:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case mainScreen:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case accountInfoScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => EditAccountInfoBloc(AccountRepository()),
            child: AccountInfoScreen(),
          ),
        );
      case searchScreen:
        return MaterialPageRoute(
          builder: (_) => FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final prefs = snapshot.data!;
              return BlocProvider(
                create: (_) => SearchBloc(SearchRepository(prefs)),
                child: const SearchScreen(),
              );
            },
          ),
        );
      case notificationScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                NotificationsCubit(NotificationRepositoryImpl()),
            child: NotificationScreen(),
          ),
        );
    }
    return null;
  }
}
