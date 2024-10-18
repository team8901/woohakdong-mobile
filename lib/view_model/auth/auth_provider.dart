import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woohakdong/service/google/google_sign_in_service.dart';

import 'components/auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final GoogleSignInService googleSignInService = GoogleSignInService();

  AuthNotifier() : super(AuthState.unauthenticated) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? accessToken = await secureStorage.read(key: 'accessToken');
    String? refreshToken = await secureStorage.read(key: 'refreshToken');

    if (accessToken != null && refreshToken != null) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> signIn() async {
    try {
      state = AuthState.loading;

      bool isSignedIn = await googleSignInService.signInWithGoogle();

      if (isSignedIn) {
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
    } catch (e) {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> signOut() async {
    try {
      state = AuthState.loading;

      bool isSignedOut = await googleSignInService.signOut();

      if (isSignedOut) {
        state = AuthState.unauthenticated;
      } else {
        state = AuthState.authenticated;
      }
    } catch (e) {
      state = AuthState.authenticated;
    }
  }
}
