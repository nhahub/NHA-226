
import 'package:shared_preferences/shared_preferences.dart';

class LocalOnboardingDataSource {
  static const String _keyIsNewUser = 'onboarding';

  Future<bool> isNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsNewUser) ?? true;
  }

  Future<void> setUserAsNotNew() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsNewUser, false);
  }
}
