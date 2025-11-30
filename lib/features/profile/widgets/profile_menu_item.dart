import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColor.text),
      title: Text(
        text,
        style: TextStyle(
          color: textColor ?? AppColor.text,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:  Icon(Icons.arrow_forward_ios, size: 16, color: AppColor.gray),
      onTap: onTap,
    );
  }
}
