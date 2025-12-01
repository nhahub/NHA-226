import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';

class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;
  const NotificationsLoaded({required this.notifications});
  List<Object> get props => [notifications];
}

final class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError({required this.message});
}
