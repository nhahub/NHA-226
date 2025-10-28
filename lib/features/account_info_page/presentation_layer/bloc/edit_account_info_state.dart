abstract class EditAccountInfoState {}

class EditAccountInitial extends EditAccountInfoState {}

class EditAccountLoading extends EditAccountInfoState {}

class EditAccountLoaded extends EditAccountInfoState {
  final String name;
  final String email;
  final String phone;

  EditAccountLoaded({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class EditProfileSuccess extends EditAccountInfoState {}

class EditProfileError extends EditAccountInfoState {
  final String message;
  EditProfileError(this.message);
}
