import 'package:firebase_auth/firebase_auth.dart';

String mapFirebaseAuthError(dynamic error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      // ===== Email & Password Auth =====
      case 'invalid-email':
        return 'That email address looks incorrect. Please check and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'We couldn’t find an account with that email.';
      case 'wrong-password':
        return 'The password you entered is incorrect.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Your password is too weak. Try using more characters and symbols.';
      case 'operation-not-allowed':
        return 'Email sign-in isn’t enabled right now.';
      case 'network-request-failed':
        return 'You’re offline. Please check your internet connection.';
      case 'requires-recent-login':
        return 'Please log in again to confirm this action.';
      case 'invalid-credential':
        return 'Your login session has expired. Please sign in again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'account-exists-with-different-credential':
        return 'This email is already linked to another sign-in method. Try using a different option.';
      case 'invalid-verification-code':
        return 'The verification code you entered is invalid.';
      case 'invalid-verification-id':
        return 'We couldn’t verify your identity. Please try again.';
      case 'popup-closed-by-user':
        return 'Sign-in was cancelled before it finished.';
      case 'unauthorized-domain':
        return 'This app isn’t authorized for Google sign-in. Please contact support.';
      case 'credential-already-in-use':
        return 'This social account is already linked to another user.';

      default:
        return 'Something went wrong. Please try again later.';
    }
  }

  final err = error.toString();

  if (err.contains('google')) {
    if (err.contains('canceled')) {
      return 'Google sign-in was cancelled.';
    }
    if (err.contains('network_error')) {
      return 'Couldn’t connect to Google. Please check your connection.';
    }
    if (err.contains('DEVELOPER_ERROR')) {
      return 'Google sign-in isn’t set up correctly. Please contact support.';
    }
    if (err.contains('sign_in_failed')) {
      return 'We couldn’t complete Google sign-in. Please try again later.';
    }
  }

  if (err.contains('facebook')) {
    if (err.contains('FACEBOOK_LOGIN_CANCELLED') ||
        err.contains('login_canceled') ||
        err.contains('canceled')) {
      return 'Facebook sign-in was cancelled.';
    }
    if (err.contains('FACEBOOK_AUTH_ERROR') || err.contains('auth_error')) {
      return 'There was a problem logging in with Facebook. Please try again.';
    }
    if (err.contains('FACEBOOK_NETWORK_ERROR') ||
        err.contains('network_error')) {
      return 'Couldn’t connect to Facebook. Please check your connection.';
    }
  }

  return 'Oops! Something went wrong. Please try again.';
}
