abstract class OnboardingRepository {
  Future<bool> isNewUser();
  Future<void> setUserAsNotNew();
}