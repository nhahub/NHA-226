import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/notification/domain/entities/app_notification.dart';
import 'package:lingo_sign/features/notification/presentation/widget/notification_cart.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: 'Notification'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: NotificationCard(
              notification: notifications[index],
              onAccept: () {},
              onIgnore: () {},
            ),
          );
        },
      ),
    );
  }
}