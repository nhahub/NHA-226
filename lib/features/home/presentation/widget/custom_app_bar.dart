import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/auth/presentation/widget/message.dart';
import 'package:lingo_sign/features/home/presentation/bloc/user_info/user_info_cubit.dart';
import 'package:shimmer/shimmer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  Widget _imageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const CircleAvatar(radius: 22, backgroundColor: Colors.white),
    );
  }

  Widget _userNameShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 100,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        bool isLoading = state is UserInfoLoading;

        return AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          title: Row(
            children: [
              if (isLoading)
                _imageShimmer()
              else if (state is UserInfoLoaded)
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColor.white,
                  backgroundImage: state.user.imageUrl.isNotEmpty
                      ? NetworkImage(state.user.imageUrl)
                      : const AssetImage('assets/images/placeholder_user.jpg')
                            as ImageProvider,
                ),
              if (state is UserInfoError)
                CircleAvatar(radius: 22, backgroundColor: Colors.red),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good Morning!',
                    style: TextStyle(
                      color: AppColor.darkGray,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isLoading)
                    _userNameShimmer()
                  else if (state is UserInfoLoaded)
                    Text(
                      state.user.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, searchScreen),
              icon: Icon(Icons.search, color: AppColor.darkGray),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, notificationScreen),
              icon: Icon(Icons.notifications, color: AppColor.darkGray),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
