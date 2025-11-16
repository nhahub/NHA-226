import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      shadowColor: Color.fromARGB(0, 255, 255, 255),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
      ),
      backgroundColor: AppColor.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
