import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lingo_sign/core/const/string.dart';
import 'package:lingo_sign/core/error/failure.dart';
import 'package:lingo_sign/core/utils/firebase_auth_error_mapper.dart';

import 'package:lingo_sign/features/auth/domain/app_user.dart';
import 'package:lingo_sign/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance.collection('users');

  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) throw AuthFailure('Login failed');
      await createUserinFirestore(userCredential.user!);
      if (userCredential.user!.emailVerified) {
        AppUser user = AppUser(uid: userCredential.user!.uid, email: email);
        return user;
      } else {
        throw AuthFailure(notVerifiedAccountStringMessage);
      }
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(mapFirebaseAuthError(e));
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user?.reload();
      final updatedUser = firebaseAuth.currentUser!;
      await createUserinFirestore(updatedUser);
      userCredential.user!.sendEmailVerification();
      return AppUser(uid: userCredential.user!.uid, email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(mapFirebaseAuthError(e));
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return null;
    return AppUser(uid: currentUser.uid, email: currentUser.email!);
  }

  @override
  Future<String> resetPasswordByEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return resetPasswordStringMessage;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(mapFirebaseAuthError(e));
    }
  }

  @override
  Future<String> verifyAccountByEmail(String email) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      currentUser!.sendEmailVerification();
      return verifyAccountStringMessage;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(mapFirebaseAuthError(e));
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) throw AuthFailure('No user logged in');
      await user.delete();
      await logout();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(mapFirebaseAuthError(e));
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  Future<AppUser?> signInWithGoogle() async {
    await _googleSignIn.initialize(serverClientId: clientId);
    try {
      final account = await _googleSignIn.authenticate();
      final auth = account.authentication;
      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) throw AuthFailure('User not found');
      await createUserinFirestore(user);
      return AppUser(uid: user.uid, email: user.email ?? '');
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthFailure(mapFirebaseAuthError('google $e'));
    }
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status != LoginStatus.success) {
        throw AuthFailure('Facebook login failed: ${loginResult.message}');
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      final firebaseUser = await FirebaseAuth.instance.signInWithCredential(
        facebookAuthCredential,
      );

      if (firebaseUser.user == null)
        // ignore: curly_braces_in_flow_control_structures
        throw AuthFailure('Facebook sign-in failed');

      await createUserinFirestore(firebaseUser.user!);

      return AppUser(
        uid: firebaseUser.user!.uid,
        email: firebaseUser.user!.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthFailure(mapFirebaseAuthError('facebook $e'));
    }
  }

  // Create User in firestore
  Future createUserinFirestore(User user) async {
    try {
      final ref = firebaseFirestore.doc(user.uid);
      final doc = await ref.get();
      if (!doc.exists) {
        await ref.set({
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email ?? 'Facebook',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Failed to create user');
    }
  }
}
