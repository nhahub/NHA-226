import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';

class FriendAccountButton extends StatelessWidget {
  const FriendAccountButton({
    super.key,
    required this.isTablet,
    required this.friend,
    required this.text,
  });
  final bool isTablet;
  final Friend friend;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isTablet ? 200 : 150,
      height: isTablet ? 60 : 50,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: AppColor.black, fontSize: isTablet ? 20 : 17),
        ),
      ),
    );
  }
}
