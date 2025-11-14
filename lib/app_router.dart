import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/auth/presentation/screen/forgot_password_screen.dart';
import 'package:lingo_sign/features/auth/presentation/screen/login_screen.dart';
import 'package:lingo_sign/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:lingo_sign/main_screen.dart';

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
    }
  }
}
