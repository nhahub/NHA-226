import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/auth/presentation/screen/forgot_password_screen.dart';
import 'package:lingo_sign/features/auth/presentation/screen/signin_screen.dart';
import 'package:lingo_sign/features/auth/presentation/screen/signup_screen.dart';

class AppRouter {
  Route? generateRouter(RouteSettings setting) {
    switch (setting.name) {
      case signinScreen:
        return MaterialPageRoute(builder: (_) => SigninScreen());
      case signupScreen:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case forgetPasswordScreen:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
    }
    return null;
  }
}
