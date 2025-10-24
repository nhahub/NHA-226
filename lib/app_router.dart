import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/search_feature/data_layer/repositories/search_repository.dart';
import 'package:lingo_sign/search_feature/presentation_layer/bloc/search_bloc.dart';
import 'package:lingo_sign/search_feature/presentation_layer/screens/profile.dart';
import 'package:lingo_sign/search_feature/presentation_layer/screens/search_screen.dart';

class AppRouter {
  Route? generateRouter(RouteSettings setting) {
    switch (setting.name) {
      case '/search':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<SearchBloc>(context),
            child: const SearchScreen(),
          ),
        );

      case '/profile':
        return MaterialPageRoute(builder: (_) => const Profile());
    }
    return null;
  }
}
