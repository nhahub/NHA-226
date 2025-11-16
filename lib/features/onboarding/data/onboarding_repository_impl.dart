import 'package:lingo_sign/features/onboarding/data/local_onboarding_data_source.dart';
import 'package:lingo_sign/features/onboarding/domain/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final LocalOnboardingDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<bool> isNewUser() async {
    return await localDataSource.isNewUser();
  }

  @override
  Future<void> setUserAsNotNew() async {
    await localDataSource.setUserAsNotNew();
  }
}
