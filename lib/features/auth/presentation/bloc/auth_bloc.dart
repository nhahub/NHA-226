import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/string.dart';
import 'package:lingo_sign/core/error/failure.dart';
import 'package:lingo_sign/features/auth/domain/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<CheckAuthEvent>(onAuthCheckEvent);
    on<LoginEvent>(onLoginEvent);
    on<RegisterEvent>(onSignupEvent);
    on<ResetPasswordEvent>(onForgotPasswordEvent);
    on<VerifyAccountEvent>(onVerifyAccountEvent);
    on<LogoutEvent>(onLogoutEvent);
    on<DeleteAccount>(onDeleteAccountEvent);
    on<SignInWithGoogleEvent>(onSignInWithGoogleEvent);
    on<SignInWithFacebookEvent>(onSignInWithFacebookEvent);
  }

  FutureOr<void> onAuthCheckEvent(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(null));
      } else {
        emit(Unauthenticated(null));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  FutureOr<void> onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.loginWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated('Logged in successfully. Welcome back!'));
      } else {
        emit(Unauthenticated('Wrong email or password'));
      }
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  FutureOr<void> onSignupEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.registerWithEmailAndPassword(
        event.name,
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated('User cearted successfully!'));
      } else {
        emit(Unauthenticated('Sign up'));
      }
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  FutureOr<void> onForgotPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      String text = await authRepository.resetPasswordByEmail(event.email);
      if (text == resetPasswordStringMessage) {
        emit(ResetPasswordState(resetPasswordStringMessage));
      } else {
        emit(ResetPasswordState('Error occurred try again'));
      }
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  FutureOr<void> onVerifyAccountEvent(
    VerifyAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      String text = await authRepository.verifyAccountByEmail(event.email);
      if (text == verifyAccountStringMessage) {
        emit(VerifyAccountState(verifyAccountStringMessage));
      } else {
        emit(VerifyAccountState('Error occurred try again'));
      }
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  FutureOr<void> onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(Unauthenticated(null));
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  FutureOr<void> onDeleteAccountEvent(
    DeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.deleteAccount();
      emit(Unauthenticated('Account deleted successfully'));
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  FutureOr<void> onSignInWithGoogleEvent(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithGoogle();
      if (user != null) {
        emit(Authenticated('Logged in successfully. Welcome back!'));
      } else {
        emit(Unauthenticated('Failed to login with google'));
      }
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  FutureOr<void> onSignInWithFacebookEvent(
    SignInWithFacebookEvent event,
    Emitter<AuthState> emit,
  ) async {
    // emit(AuthLoading());
    // try {
    //   final user = await authRepository.signInWithFacebook();
    //   // ignore: unnecessary_null_comparison
    //   if (user != null) {
    //     emit(Authenticated());
    //   } else {
    //     emit(Unauthenticated('Error With github'));
    //   }
    // } on Failure catch (failure) {
    //   emit(AuthError(failure.message));
    // } catch (e) {
    //   emit(AuthError('Something went wrong. Please try again.'));
    // }
  }
}
