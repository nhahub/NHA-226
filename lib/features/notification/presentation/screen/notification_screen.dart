import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_cubit.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_state.dart';
import 'package:lingo_sign/features/notification/presentation/widget/notification_cart.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationsCubit>();
    cubit.listenToNotificationsRealTime();
    Future.delayed(Duration(milliseconds: 100), () {
      cubit.markAllNotificationsAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: "Notifications"),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading || state is NotificationsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationsError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          if (state is NotificationsLoaded) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return const Center(child: Text("No notifications right now!"));
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                if (notif.isIgnored) return const SizedBox.shrink();
                return NotificationCard(
                  notification: notif,
                  onAccept: notif.fromUserId.isEmpty
                      ? null
                      : () => context
                            .read<NotificationsCubit>()
                            .acceptNotification(
                              requestNotifId: notif.id,
                              senderId: notif.fromUserId,
                            ),
                  onIgnore: () {
                    final cubit = context.read<NotificationsCubit>();
                    cubit.ignoreNotification(requestNotifId: notif.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Notification ignored"),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            cubit.undoIgnoreNotification(
                              requestNotifId: notif.id,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
