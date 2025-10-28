import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/screens/account_info_screen.dart';

abstract class EditAccountInfoState extends Equatable {
  const EditAccountInfoState();
  @override
  List<Object> get props => [];
}

class EditAccountInitial extends EditAccountInfoState {}

class EditAccountLoading extends EditAccountInfoState {}

class EditAccountLoaded extends EditAccountInfoState {
  final String name;
  final String email;
  final String phone;

  const EditAccountLoaded({
    required this.name,
    required this.email,
    required this.phone,
  });
  @override
  List<Object> get props => [name, email, phone];
}

class AccountInfoUpdated extends EditAccountInfoState {}

class EditAccountError extends EditAccountInfoState {
  final String message;
  const EditAccountError(this.message);
  @override
  List<Object> get props => [message];
}
