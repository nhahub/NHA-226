import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/home/domain/entities/user_app.dart';
import 'package:lingo_sign/features/home/domain/home_repository.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  HomeRepository homeRepository;
  UserInfoCubit(this.homeRepository) : super(UserInfoInitial());

  Future getUserInfo() async {
    emit(UserInfoLoading());
    try {
      final user = await homeRepository.getUserInfo();
      emit(UserInfoLoaded(user));
    } catch (e) {
      emit(UserInfoError(e.toString()));
    }
  }
}
