import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'send_us_state.dart';

class SendUsCubit extends Cubit<SendUsState> {
  SendUsCubit() : super(SendUsInitial());
  void sendMessage(String message){
    emit(SendingMessage(message));
  }
}
