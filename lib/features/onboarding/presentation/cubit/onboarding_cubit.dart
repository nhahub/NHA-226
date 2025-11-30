import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/onboarding/domain/onboarding_repository.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository onboardingRepository;

  OnboardingCubit(this.onboardingRepository) : super(OnboardingInitial());

  Future<void> checkUserStatus() async {
    emit(OnboardingLoading());
    final isNew = await onboardingRepository.isNewUser();
    if (isNew) {
      emit(UserIsNew());
    } else {
      emit(UserIsReturning());
    }
  }

  Future<void> completeOnboarding() async {
    await onboardingRepository.setUserAsNotNew();
    emit(UserIsReturning());
  }
}
