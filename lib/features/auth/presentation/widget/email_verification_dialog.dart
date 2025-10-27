import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class EmailVerificationDialog extends StatefulWidget {
  const EmailVerificationDialog({
    super.key,
    required this.onResend,
    required this.isLoading,
    required this.isSent,
  });

  final VoidCallback onResend;
  final bool isLoading;
  final bool isSent;

  @override
  State<EmailVerificationDialog> createState() =>
      _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor().white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.email_outlined, color: Colors.pink),
          SizedBox(width: 8),
          Text("Verify your email"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Please verify your email address to continue. Check your inbox or resend a new verification email.",
            textAlign: TextAlign.left,
          ),
          if (widget.isSent)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                "Verification email sent! Check your inbox.",
                style: TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.isLoading ? null : () async => widget.onResend(),
          child: widget.isSent
              ? Text('')
              : widget.isLoading
              ? const CircularProgressIndicator()
              : const Text("Resend"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
