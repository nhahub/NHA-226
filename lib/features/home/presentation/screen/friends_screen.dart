import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().white,
      
      body: Center(child: Text('Friends')),
    );
  }
}
