import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/search/data/model/user_model.dart';

class CustomSearchUser extends StatelessWidget {
  const CustomSearchUser({super.key, required this.user});
  
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColor.white,
                backgroundImage: user.image.isNotEmpty
                    ? NetworkImage(user.image)
                    : AssetImage('assets/images/placeholder_user.jpg'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Text(
                  //   user.lastSeen,
                  //   style: const TextStyle(color: Colors.grey),
                  // ),
                ],
              ),
            ],
          ),
          InkWell(
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColor.main,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.call, color: AppColor.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
