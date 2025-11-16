import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/call/call_system/call_service.dart';
import 'package:lingo_sign/features/call/screen/incoming_call_screen.dart';
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
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    CallService().onIncomingCall(auth.currentUser!.uid).listen((call) {
      if (call == null) return;
      if (call.status == "ringing") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => IncomingCallScreen(call: call)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
