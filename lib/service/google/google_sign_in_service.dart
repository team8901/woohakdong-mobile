import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../repository/auth/woohakdong_auth_repository.dart';
import '../../service/logger/logger.dart';

class GoogleSignInService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final WoohakdongAuthRepository _auth = WoohakdongAuthRepository();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        logger.w("구글 로그인 취소");
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? googleAccessToken = googleAuth.accessToken;
      final String? googleIdToken = googleAuth.idToken;

      //print('googleAccessToken: $googleAccessToken');

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAccessToken,
        idToken: googleIdToken,
      );

      // ignore: unused_local_variable
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (googleAccessToken != null) {
        final tokens = await _auth.logIn(googleAccessToken);

        if (tokens != null) {
          final String accessToken = tokens['accessToken']!;
          final String refreshToken = tokens['refreshToken']!;

          await _secureStorage.write(key: 'accessToken', value: accessToken);
          await _secureStorage.write(key: 'refreshToken', value: refreshToken);

          logger.i("구글 로그인 성공");

          return true;
        } else {
          logger.w("토큰 발급 실패");
          await _firebaseAuth.signOut();
          await _googleSignIn.signOut();
          return false;
        }
      } else {
        logger.w("구글 액세스 토큰 없음");
        return false;
      }
    } catch (e) {
      logger.e("구글 로그인 실패", error: e);
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      final String? refreshToken = await _secureStorage.read(key: 'refreshToken');

      if (refreshToken != null) {
        await _auth.logOut(refreshToken);
      } else {
        logger.w("리프레쉬 토큰 없음");
        return false;
      }

      await _secureStorage.deleteAll();

      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      logger.i("로그아웃 성공");
      return true;
    } catch (e) {
      logger.e("로그아웃 실패", error: e);
      return false;
    }
  }
}
