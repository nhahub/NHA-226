import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/search_feature/data_layer/model/user_model.dart';

// ignore: must_be_immutable
class CustomSearchUser extends StatelessWidget {
  final UserModel user;

  const CustomSearchUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        width: 344.w,
        height: 56.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    user.image.isNotEmpty
                        ? user.image
                        : 'assets/images/placeholder_user.jpg',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 16.w),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: TextStyle(fontSize: 16.h, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Spacer(),

            Container(
              width: 36.w,
              height: 36.h,
              decoration: const BoxDecoration(
                color: Color(0xff31326F),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.call, color: Colors.white, size: 20.h),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
