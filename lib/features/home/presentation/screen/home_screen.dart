import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
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
  List<Widget> sections = [FriendsScreen(), const LastCallScreen(), const RequestsScreen()];

  late TabController _tabController;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
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
