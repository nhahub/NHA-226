import 'package:flutter/material.dart';
import 'package:lingo_sign/search_feature/presentation_layer/screens/profile.dart';
import 'package:lingo_sign/search_feature/presentation_layer/screens/search_screen.dart';

class AppRouter {
  Route? generateRouter(RouteSettings setting) {
    switch (setting.name) {
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case '/profile':
        return MaterialPageRoute(builder: (_) => const Profile());
    }
  }
}
