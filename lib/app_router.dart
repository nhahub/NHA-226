import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/account_info_page/data_layer/user_repository.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_bloc.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_event.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/screens/account_info_screen.dart';
import 'package:lingo_sign/features/search_feature/data_layer/repositories/search_repository.dart';
import 'package:lingo_sign/features/search_feature/presentation_layer/bloc/search_bloc.dart';
import 'package:lingo_sign/features/search_feature/presentation_layer/screens/profile.dart';
import 'package:lingo_sign/features/search_feature/presentation_layer/screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  Route? generateRouter(RouteSettings setting) {
    switch (setting.name) {
      case '/search':
        return MaterialPageRoute(
          builder: (_) => FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final prefs = snapshot.data!;
              return BlocProvider(
                create: (_) => SearchBloc(
                  SearchRepository(FirebaseFirestore.instance, prefs),
                ),
                child: const SearchScreen(),
              );
            },
          ),
        );

      case '/profile':
        return MaterialPageRoute(builder: (_) => const Profile());
      case '/profile/account_info':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                EditAccountInfoBloc(UserRepository())..add(LoadUserData()),
            child: AccountInfoScreen(),
          ),
        );
    }
    return null;
  }
}
