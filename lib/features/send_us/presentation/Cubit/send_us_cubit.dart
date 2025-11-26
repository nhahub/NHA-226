import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../data/send_us_service.dart';

part 'send_us_state.dart';

class SendUsCubit extends Cubit<SendUsState> {
  final SendEmailService emailService;
  SendUsCubit({required this.emailService}) : super(SendUsInitial());

  Future<void> sendMessage(String message) async {
    emit(SendUsLoading());

    try {
      await emailService.sendEmail(message);
      emit(SendUsSuccess());
    } catch (e) {
      emit(SendUsError(e.toString()));
    }
  }
}
