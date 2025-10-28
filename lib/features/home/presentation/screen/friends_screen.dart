import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/auth/presentation/bloc/auth_bloc.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Center(
        child: Column(
          children: [
            Text('Friends'),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      loginScreen,
                      (context) => false,
                    );
                  },
                  icon: Icon(Icons.logout),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
