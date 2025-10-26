import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class SigninHeader extends StatelessWidget {
  const SigninHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColor().main,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(160)),
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 15,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
