import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/transelation/data/translation_repository_impl.dart';

part 'translation_state.dart';

class TranslationCubit extends Cubit<TranslationState> {
  final TranslationRepositoryImpl repository;
  TranslationCubit(this.repository) : super(TranslationInitial());

  Future<String> getTranslation(String path) async {
    try {
      emit(TranslationLoading());
      final translation = await repository.getTranslation(path);
      emit(TranslationLoaded(translation));
      return translation;
    } catch (e) {
      emit(TranslationError(e.toString()));
      return "";
    }
  }
}
