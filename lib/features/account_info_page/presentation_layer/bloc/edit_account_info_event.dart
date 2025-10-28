abstract class EditAccountInfoEvent {}

class LoadUserData extends EditAccountInfoEvent {}

class UpdateUserData extends EditAccountInfoEvent {
  final String? name;
  final String? email;
  final String? phone;

  UpdateUserData({this.name, this.email, this.phone});
}
