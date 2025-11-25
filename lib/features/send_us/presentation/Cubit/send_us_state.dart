part of 'send_us_cubit.dart';

@immutable
sealed class SendUsState {
  String message;

  SendUsState(this.message);
}

final class SendUsInitial extends SendUsState {
  SendUsInitial():super("");
}
class SendingMessage extends SendUsState{
  SendingMessage(super.message);
}
