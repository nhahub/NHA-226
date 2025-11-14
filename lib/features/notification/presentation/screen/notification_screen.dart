import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_cubit.dart';
import 'package:lingo_sign/features/notification/presentation/widget/notification_cart.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<AppNotification> notifications = [
    AppNotification(
      title: 'Mohamed want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(hours: 4)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Missed call from Sarah',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(hours: 6, minutes: 12)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Ali want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Missed call from John',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Nour want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(minutes: 45)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Missed call from Karim',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(hours: 10, minutes: 20)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Aya want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Missed call from Lina',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Omar want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Missed call from Salma',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(minutes: 30)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Youssef want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(days: 4, hours: 2)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Missed call from Hossam',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(days: 5, hours: 5)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Layla want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(days: 6, hours: 4)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Missed call from Ahmed',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Mona want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Missed call from Tamer',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(hours: 8, minutes: 5)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Sara want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Missed call from Karim',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      isSeen: true,
    ),
    AppNotification(
      title: 'Missed call from Adam',
      notificationType: NotificationType.missedCall,
      date: DateTime.now().subtract(const Duration(hours: 3)),
      isSeen: false,
    ),
    AppNotification(
      title: 'Hana want to be your friend',
      notificationType: NotificationType.request,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      isSeen: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getallNotification();
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
              return Center(child: CircularProgressIndicator());
            }
            if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return Center(
                  child: Text(
                    'There are no notification yet!',
                    style: TextStyle(color: AppColor.black),
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
                  style: TextStyle(color: AppColor.black),
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
