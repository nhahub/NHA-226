import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lingo_sign/features/account_info_page/presentation_layer/widgits/custom_info_feild.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24.h),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Account information',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.h,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomInfoFeild(description: 'Full Name'),
          CustomInfoFeild(description: 'Phone Number'),
          CustomInfoFeild(description: 'Email'),
        ],
      ),
    );
  }
}
