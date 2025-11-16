import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_cubit.dart';
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
