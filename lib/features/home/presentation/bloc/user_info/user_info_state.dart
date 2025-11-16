part of 'user_info_cubit.dart';

sealed class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object> get props => [];
}

final class UserInfoInitial extends UserInfoState {}

final class UserInfoLoading extends UserInfoState {}

final class UserInfoLoaded extends UserInfoState {
  final UserApp user;

  const UserInfoLoaded(this.user);
}

final class UserInfoError extends UserInfoState {
  final String message;

  const UserInfoError(this.message);
}
