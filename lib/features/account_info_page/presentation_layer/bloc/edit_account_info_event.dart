import 'package:equatable/equatable.dart';

abstract class EditAccountInfoEvent extends Equatable {}

class LoadUserData extends EditAccountInfoEvent {
  @override
  List<Object?> get props => [];
}

class UpdateUserData extends EditAccountInfoEvent {
  final String? name;
  final String? email;
  final String? phone;

  UpdateUserData({this.name, this.email, this.phone});
  @override
  List<Object?> get props => [name, email, phone];
}
