import 'package:lingo_sign/features/auth/domain/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> loginWithEmailAndPassword(String email, String password);

  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  );

  Future<AppUser?> getCurrentUser();

  Future<String> resetPasswordByEmail(String email);

  Future<String> verifyAccountByEmail(String email);

  Future<void> logout();

  Future<void> deleteAccount();

  Future<AppUser?> signInWithGoogle();

  Future<AppUser> signInWithFacebook();
}
