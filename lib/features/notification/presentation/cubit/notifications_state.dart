import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/notification/domain/app_notification.dart';

abstract class NotificationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;
  NotificationsLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}
