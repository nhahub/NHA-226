part of 'send_us_cubit.dart';

@immutable
sealed class SendUsState {}

final class SendUsInitial extends SendUsState {}

class SendUsLoading extends SendUsState {}

class SendUsSuccess extends SendUsState {}

class SendUsError extends SendUsState {
  final String errorMessage;
  SendUsError(this.errorMessage);
}
