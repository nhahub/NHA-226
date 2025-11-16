import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/account_info_page/data/account_repository.dart';
import 'package:lingo_sign/features/account_info_page/presentation/bloc/edit_account_info_event.dart';
import 'package:lingo_sign/features/account_info_page/presentation/bloc/edit_account_info_state.dart';

class EditAccountInfoBloc
    extends Bloc<EditAccountInfoEvent, EditAccountInfoState> {
  final AccountRepository repository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isEditing = false;

  EditAccountInfoBloc(this.repository) : super(EditAccountInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<UpdateUserData>(_onUpdateUserData);
    on<ToggleEditMode>((event, emit) {
      isEditing = !isEditing;
      emit(EditModeState(isEditing));
    });
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<EditAccountInfoState> emit,
  ) async {
    emit(EditAccountLoading());
    try {
      final userId = _auth.currentUser!.uid;
      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();
      emit(
        EditAccountLoaded(
          name: data?['name'] ?? '',
          email: data?['email'] ?? '',
          phone: data?['phone'] ?? '',
        ),
      );
    } catch (e) {
      emit(EditAccountError('Failed to load user data: $e'));
    }
  }

  Future<void> _onUpdateUserData(
    UpdateUserData event,
    Emitter<EditAccountInfoState> emit,
  ) async {
    emit(EditAccountLoading());
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(userId).update({
        'name': event.name,
        'email': event.email,
        'phone': event.phone,
      });
      emit(AccountInfoUpdated());
      add(LoadUserData()); // reload data
    } catch (e) {
      emit(EditAccountError('Failed to update user data: $e'));
    }
  }
}
