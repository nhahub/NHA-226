import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Center(child: CircularProgressIndicator(color: AppColor.main)),
    );
  }
}
