import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: 59,
        height: 59,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {},
          backgroundColor: AppColor.main,
          child: Icon(Icons.add, color: AppColor.white),
        ),
      ),
    );
  }
}
