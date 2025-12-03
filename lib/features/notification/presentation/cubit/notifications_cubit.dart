import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';
import 'package:lingo_sign/features/notification/domain/notification_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository repository;
  StreamSubscription<List<AppNotification>>? _realtimeSub;

  NotificationsCubit(this.repository) : super(NotificationsInitial());

  Future<void> getAllNotifications() async {
    emit(NotificationsLoading());
    try {
      final notifications = await repository.getallNotification();
      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  void listenToNotificationsRealTime() {
    _realtimeSub?.cancel();
    _realtimeSub = repository.getallNotificationStream().listen((
      notifications,
    ) {
      emit(NotificationsLoaded(notifications: notifications));
    }, onError: (e) => emit(NotificationsError(message: e.toString())));
  }

  Future<void> markAllNotificationsAsRead() async {
    if (state is! NotificationsLoaded) return;
    final notifications = (state as NotificationsLoaded).notifications;
    for (final notif in notifications) {
      if (!notif.isRead) {
        await repository.markAsRead(notif.id);
      }
    }
    getAllNotifications();
  }

  Future<void> acceptNotification({
    required String requestNotifId,
    required String senderId,
  }) async {
    try {
      await repository.sendAcceptNotification(
        requestNotifId: requestNotifId,
        senderId: senderId,
      );
      getAllNotifications();
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  Future<void> ignoreNotification({required String requestNotifId}) async {
    try {
      await repository.ignoreNotification(requestNotifId: requestNotifId);
      getAllNotifications();
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  Future<void> undoIgnoreNotification({required String requestNotifId}) async {
    try {
      await repository.undoIgnoreNotification(requestNotifId: requestNotifId);
      getAllNotifications();
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _realtimeSub?.cancel();
    return super.close();
  }
}
