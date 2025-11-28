import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/transelation/data/translation_repository_impl.dart';


part 'translation_state.dart';

class TranslationCubit extends Cubit<TranslationState> {
  final TranslationRepositoryImpl repository;
  TranslationCubit(this.repository) : super(TranslationInitial());

  Future<String> getUserName() async {
    try {
      emit(TranslationLoading());
      final name = await repository.getUserName();
      emit(TranslationLoaded(name));
      return name;
    } catch (e) {
      emit(TranslationError(e.toString()));
      return "";
    }
  }
}
