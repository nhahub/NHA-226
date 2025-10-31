import 'package:flutter/material.dart';

import 'package:lingo_sign/core/const/screen_name.dart';

import 'package:lingo_sign/features/account_info_page/presentation_layer/screens/account_info_screen.dart';

class AppRouter {
  Route? generateRouter(RouteSettings setting) {
    switch (setting.name) {
      case accountInfoScreen:
        return MaterialPageRoute(builder: (context) => AccountInfoScreen());
    }
  }
}
