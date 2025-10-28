import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SigninWithFacebookButton extends StatelessWidget {
  const SigninWithFacebookButton({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xffFAFAFA),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset('assets/images/facebook_logo.svg', width: 42),
        ),
      ),
    );
  }
}
