import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/account_info_page/data_layer/account_repository.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_bloc.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/screens/account_info_screen.dart';

class AppRouter {
  Route? generateRouter(RouteSettings setting) {
    switch (setting.name) {
      case accountInfoScreen:
        return MaterialPageRoute(
          builder: (context) {
            final firestore = FirebaseFirestore.instance;
            final auth = FirebaseAuth.instance;
            return BlocProvider(
              create: (context) =>
                  EditAccountInfoBloc(AccountRepository(firestore, auth)),
              child: AccountInfoScreen(),
            );
          },
        );
    }
    return null;
  }
}
