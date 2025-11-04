import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lingo_sign/features/notification/domain/app_notification.dart';
import 'package:lingo_sign/features/notification/domain/notification_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationRepository notificationRepository;

  NotificationsCubit(this.notificationRepository)
    : super(NotificationsInitial());

  Future<List<AppNotification>?> getallNotification() async {
    emit(NotificationsLoading());
    try {
      final notifications = await notificationRepository.getallNotification();
      emit(NotificationsLoaded(notifications: notifications));
      return notifications;
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
    return null;
  }
}
