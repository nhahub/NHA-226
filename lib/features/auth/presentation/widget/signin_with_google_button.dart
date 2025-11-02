import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SigninWithGoogleButton extends StatefulWidget {
  const SigninWithGoogleButton({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<SigninWithGoogleButton> createState() => _SigninWithGoogleButtonState();
}

class _SigninWithGoogleButtonState extends State<SigninWithGoogleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffFAFAFA),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: SvgPicture.asset('assets/images/google_logo.svg', width: 42),
        ),
      ),
    );
  }
}
