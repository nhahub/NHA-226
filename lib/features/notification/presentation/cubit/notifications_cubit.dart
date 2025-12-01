import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';
import 'package:lingo_sign/features/notification/domain/notification_repository.dart';
import 'package:lingo_sign/features/notification/presentation/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository notificationRepository;
  Stream<List<AppNotification>>? _notifStreamSubscription;

  NotificationsCubit(this.notificationRepository)
    : super(NotificationsInitial()) {
    getallNotification();
  }

  void getallNotification() {
    emit(NotificationsLoading());
    _notifStreamSubscription = notificationRepository
        .getallNotificationStream();
    _notifStreamSubscription!.listen(
      (notifications) {
        emit(NotificationsLoaded(notifications: notifications));
      },
      onError: (error) {
        emit(NotificationsError(message: error.toString()));
      },
    );
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
      final updatedNotifications = currentState.notifications
          .where((notif) => notif.id != requestNotifId)
          .toList();
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
      final updatedNotifications = currentState.notifications
          .where((notif) => notif.id != requestNotifId)
          .toList();
      emit(NotificationsLoaded(notifications: updatedNotifications));
    }

    await notificationRepository.ignoreNotification(
      requestNotifId: requestNotifId,
    );
  }

  int unseenCount() {
    if (state is NotificationsLoaded) {
      return (state as NotificationsLoaded).notifications
          .where((notif) => !notif.isRead)
          .length;
    }
    return 0;
  }
}
