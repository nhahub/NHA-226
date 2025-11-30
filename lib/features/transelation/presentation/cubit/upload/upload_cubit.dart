import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/transelation/data/translation_repository_impl.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  final TranslationRepositoryImpl repository;
  UploadCubit(this.repository) : super(UploadInitial());

  Future<void> uploadVideo() async {
    try {
      emit(UploadLoading());
      final path = await repository.uploadVideo();
      emit(UploadLoaded(path));
      
    } catch (e) {
      emit(UploadErorr(e.toString()));
      
    }
  }
}
