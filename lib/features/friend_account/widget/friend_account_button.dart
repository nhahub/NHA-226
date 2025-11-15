import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FriendAccountButton extends StatelessWidget {
  const FriendAccountButton({
    super.key,
    required this.isTablet,
    required this.friend,
    required this.text,
    this.onTap,
  });

  final bool isTablet;
  final Friend friend;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isTablet ? 200 : 95,
      height: isTablet ? 60 : 50,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              overflow: TextOverflow.visible,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.black,
                fontSize: isTablet ? 20 : 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
