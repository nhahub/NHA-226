import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/core/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_cubit.dart';
import 'package:lingo_sign/features/notification/presentation/widget/notification_cart.dart';
import 'package:lingo_sign/features/notification/presentation/widget/notification_shimmer_cart.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  @override
  void initState() {
    super.initState();

    final cubit = context.read<NotificationsCubit>();
    cubit.getallNotification().then((notifications) {
      if (notifications != null) {
        for (final notif in notifications) {
          if (!notif.isRead) {
            cubit.markAsRead(notif.id);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: CustomAppBar(title: 'Notification'),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => NotificationShimmerCart(),
              );
            }
            if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: context.width / 2),
                      SvgPicture.asset('assets/images/empty_notification.svg'),
                      Text(
                        'No notifications right now!',
                        style: TextStyle(color: AppColor.main, fontSize: 20.sp),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: NotificationCard(
                      notification: state.notifications[index],
                      onAccept: () {},
                      onIgnore: () {},
                    ),
                  );
                },
              );
            }
            if (state is NotificationsError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: AppColor.main, fontSize: 18),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
