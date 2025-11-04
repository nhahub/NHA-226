part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  final String? message;
  const Authenticated(this.message);
}

final class Unauthenticated extends AuthState {
  final String? unauthenticatedMessage;
  const Unauthenticated(this.unauthenticatedMessage);
}

final class ResetPasswordState extends AuthState {
  final String message;
  const ResetPasswordState(this.message);
}

final class NotVerifyAccountState extends AuthState {
  final String message;
  const NotVerifyAccountState(this.message);
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
