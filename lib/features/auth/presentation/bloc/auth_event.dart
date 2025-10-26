part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email, password;
  const LoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final String name, email, password;
  const RegisterEvent(this.name, this.email, this.password);
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  const ResetPasswordEvent(this.email);
}

class VerifyAccountEvent extends AuthEvent {
  final String email;
  const VerifyAccountEvent(this.email);
}

class LogoutEvent extends AuthEvent {}

class DeleteAccount extends AuthEvent {}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithFacebookEvent extends AuthEvent {}