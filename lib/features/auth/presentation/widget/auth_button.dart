import 'package:flutter/material.dart';
import 'package:lingo_sign/core/utils/helper.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    this.onTap,
    required this.isLoading,
    required this.text,
  });

  final VoidCallback? onTap;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? () {} : onTap,
      child: Container(
        width: context.width,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff31326F),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: isLoading
                ? SizedBox(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
