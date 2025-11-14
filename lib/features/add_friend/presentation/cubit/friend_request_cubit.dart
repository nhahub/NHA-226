import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/add_friend/domain/request_friend_repository.dart';

part 'friend_request_state.dart';

class FriendRequestCubit extends Cubit<FriendRequestState> {
  final RequestFriendRepository requestFriendRepository;
  FriendRequestCubit(this.requestFriendRepository)
    : super(FriendRequestInitial());

  Future<void> sendRequest(String email) async {
    emit(FriendRequestLoading());
    try {
      await requestFriendRepository.sendFriendRequest(email);
      emit(FriendRequestSuccess());
    } catch (e) {
      emit(FriendRequestError(e.toString()));
    }
  }
}
