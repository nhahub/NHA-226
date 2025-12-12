import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/widget/custom_bottom_navigation_bar.dart';
import 'package:lingo_sign/features/home/presentation/screen/home_screen.dart';
import 'package:lingo_sign/features/profile/presentation/screen/profile_screen.dart';
import 'package:lingo_sign/features/transelation/presentation/screen/translation_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> screen = [
    TranslationScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];
  int index = 1;
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: screen[index],
        bottomNavigationBar: CustomBottomNavigationBar(
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),
      ),
    );
  }
}
