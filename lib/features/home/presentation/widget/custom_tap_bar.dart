import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class CustomTapBar extends StatelessWidget {
  const CustomTapBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColor().white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TabBar(
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: AppColor().main,
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          indicator: BoxDecoration(
            color: AppColor().main,
            borderRadius: BorderRadius.circular(12),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(child: Text('Friends', style: TextStyle(fontSize: 14))),
            Tab(child: Text('Last call')),
            Tab(child: Text('Request')),
          ],
        ),
      ),
    );
  }
}
