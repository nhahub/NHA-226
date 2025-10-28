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
  List<Widget> sections = [FriendsScreen(), LastCallScreen(), RequestsScreen()];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        name: 'Mohamed AlAzab',
        imageUrl:
            'https://media.licdn.com/dms/image/v2/D5603AQEUdpkTlQjVRQ/profile-displayphoto-scale_400_400/B56ZgnhQ42H0Ak-/0/1753009688865?e=1762992000&v=beta&t=SFU2yF_lHcxGTVTp9sHwvHFFUOH3sE6Ta4r_N3IZ2SI',
      ),
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
