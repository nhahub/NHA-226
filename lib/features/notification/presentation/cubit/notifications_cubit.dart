import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';
import 'package:lingo_sign/features/notification/domain/notification_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository notificationRepository;

  NotificationsCubit(this.notificationRepository)
    : super(NotificationsInitial());

  Future<void> getallNotification() async {
    emit(NotificationsLoading());
    try {
      final notifications = await notificationRepository.getallNotification();
      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  Future<void> markAsRead(String? notifId) async {
    if (notifId == null || notifId.isEmpty) return;

    final currentState = state;
    if (currentState is NotificationsLoaded) {
      final updatedNotifications = currentState.notifications.map((notif) {
        if (notif.id == notifId) {
          return AppNotification(
            id: notif.id,
            title: notif.title,
            type: notif.type,
            createdAt: notif.createdAt,
            isRead: true,
            fromUserId: notif.fromUserId,
          );
        }
        return notif;
      }).toList();

      emit(NotificationsLoaded(notifications: updatedNotifications));
    }

    await notificationRepository.markAsRead(notifId);
  }

  Future<void> acceptNotification({
    required String? requestNotifId,
    required String? senderId,
  }) async {
    if (requestNotifId == null ||
        requestNotifId.isEmpty ||
        senderId == null ||
        senderId.isEmpty)
      return;

    final currentState = state;
    if (currentState is NotificationsLoaded) {
      final updatedNotifications = currentState.notifications.map((notif) {
        if (notif.id == requestNotifId) {
          return AppNotification(
            id: notif.id,
            title: notif.title,
            type: NotificationType.accepted,
            createdAt: notif.createdAt,
            isRead: true,
            fromUserId: notif.fromUserId,
          );
        }
        return notif;
      }).toList();

      emit(NotificationsLoaded(notifications: updatedNotifications));
    }

    await notificationRepository.sendAcceptNotification(
      requestNotifId: requestNotifId,
      senderId: senderId,
    );
  }

  Future<void> ignoreNotification({required String? requestNotifId}) async {
    if (requestNotifId == null || requestNotifId.isEmpty) return;

    final currentState = state;
    if (currentState is NotificationsLoaded) {
      final updatedNotifications = currentState.notifications.map((notif) {
        if (notif.id == requestNotifId) {
          return notif.copyWith(isIgnored: true);
        }
        return notif;
      }).toList();

      emit(NotificationsLoaded(notifications: updatedNotifications));
    }

    await notificationRepository.ignoreNotification(
      requestNotifId: requestNotifId,
    );
  }
}
