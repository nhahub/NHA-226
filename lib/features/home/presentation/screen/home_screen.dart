import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/domain/entities/user_app.dart';
import 'package:lingo_sign/features/home/presentation/screen/friends_screen.dart';
import 'package:lingo_sign/features/home/presentation/screen/last_call_screen.dart';
import 'package:lingo_sign/features/home/presentation/screen/requests_screen.dart';
import 'package:lingo_sign/features/home/presentation/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/home/presentation/widget/custom_tap_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> sections = [FriendsScreen(), LastCallScreen(), RequestsScreen()];

  late TabController _tabController;

  final UserApp user = UserApp(
    uid: '',
    name: 'Mohamed.A',
    imageUrl:
        'https://idfzqftyfepzfypxwmst.supabase.co/storage/v1/object/sign/user_images/linkedinPhoto-2.JPG?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV9kNmVlMDZmNy05YTg4LTQzYmYtODliZS01MDA4ZTljN2FjYmMiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJ1c2VyX2ltYWdlcy9saW5rZWRpblBob3RvLTIuSlBHIiwiaWF0IjoxNzYyMTkxMjY3LCJleHAiOjE3OTM3MjcyNjd9.G-BMkHqZCv7j7mPirc0fc1gKHkcTFUziVw2IxXqy3lo',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: user),
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          CustomTapBar(tabController: _tabController),
          Expanded(
            child: TabBarView(controller: _tabController, children: sections),
          ),
        ],
      ),
    );
  }
}
