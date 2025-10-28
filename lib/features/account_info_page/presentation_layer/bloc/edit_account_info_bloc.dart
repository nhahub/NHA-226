import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/account_info_page/data_layer/user_repository.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_event.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_state.dart';

class EditAccountInfoBloc
    extends Bloc<EditAccountInfoEvent, EditAccountInfoState> {
  final UserRepository userRepository;

  EditAccountInfoBloc(this.userRepository) : super(EditAccountInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<UpdateUserData>(_onUpdateUserData);
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<EditAccountInfoState> emit,
  ) async {
    emit(EditAccountLoading());
    try {
      final data = await userRepository.getUserData();
      emit(
        EditAccountLoaded(
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
        ),
      );
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateUserData(
    UpdateUserData event,
    Emitter<EditAccountInfoState> emit,
  ) async {
    final name = event.name?.trim() ?? '';
    final email = event.email?.trim() ?? '';
    final phone = event.phone?.trim() ?? '';

    if (event.name!.isEmpty) {
      emit(EditProfileError("Name can't be empty"));
      return;
    }
    if (event.name!.length < 3) {
      emit(EditProfileError("Phone number must be at least 10 digits"));
      return;
    }
    if (event.email!.isEmpty) {
      emit(EditProfileError("Email can't be empty"));
      return;
    }
    if (!event.email!.contains('@')) {
      emit(EditProfileError("Invalid email address"));
      return;
    }

    if (event.phone!.isEmpty) {
      emit(EditProfileError("Phone Number can't be empty"));
      return;
    }
    if (event.phone!.length < 10) {
      emit(EditProfileError("Phone number must be at least 10 digits"));
      return;
    }

    emit(EditAccountLoading());
    try {
      await userRepository.updateUserData(
        name: event.name,
        email: event.email,
        phone: event.phone,
      );

      emit(EditProfileSuccess());
      add(LoadUserData()); // Reload updated data
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }
}
