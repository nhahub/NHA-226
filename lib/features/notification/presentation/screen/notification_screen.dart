import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/core/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_cubit.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_state.dart';
import 'package:lingo_sign/features/notification/presentation/widget/notification_cart.dart';
import 'package:lingo_sign/features/notification/presentation/widget/notification_shimmer_cart.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomAppBar(title: 'Notification'),
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
                  final notif = state.notifications[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: NotificationCard(
                      notification: notif,
                      onAccept: () async {
                        final cubit = context.read<NotificationsCubit>();
                        await cubit.acceptNotification(
                          requestNotifId: notif.id,
                          senderId: notif.fromUserId,
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('You accepted the request')),
                        );
                      },
                      onIgnore: () async {
                        final cubit = context.read<NotificationsCubit>();
                        await cubit.ignoreNotification(
                          requestNotifId: notif.id,
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Notification ignored'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () async {
                                await cubit.markAsRead(
                                  notif.id,
                                ); // undo mark as read
                              },
                            ),
                          ),
                        );
                      },
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
