import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/call/data/call_firestore_service.dart';
import 'package:lingo_sign/features/call/services/incoming_call_handler.dart';
import 'package:lingo_sign/features/home/presentation/bloc/user_info/user_info_cubit.dart';
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
    CallFirestoreService().onIncomingCall(auth.currentUser!.uid).listen((
      callData,
    ) {
      if (callData != null) {
        IncomingCallHandler().handleIncoming(callData, context);
      }
    });
    context.read<UserInfoCubit>().getUserInfo();
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
