import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_login_result.dart';

/// 구글 로그인 전용 서비스 (웹: signInWithPopup, 모바일: google_sign_in + credential)
/// 다른 화면/기능에서도 import 해서 사용 가능
class GoogleLoginService {
  GoogleLoginService._();

  static GoogleSignIn? _googleSignIn;

  static GoogleSignIn get _mobileGoogleSignIn {
    _googleSignIn ??= GoogleSignIn(clientId: null);
    return _googleSignIn!;
  }

  /// 구글 로그인 실행
  /// - 웹: Firebase Auth signInWithPopup(GoogleAuthProvider)
  /// - 모바일: GoogleSignIn → credential → signInWithCredential
  static Future<GoogleLoginResult> signIn() async {
    final auth = FirebaseAuth.instance;
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        // 같은 브라우저 세션에서 이전 계정(A)이 자동으로 재사용되는 것을 막기 위해
        // 로그인 시 계정 선택을 강제한다.
        provider.setCustomParameters({'prompt': 'select_account consent'});
        await auth.signInWithPopup(provider);
        return const GoogleLoginResult(success: true);
      } else {
        final googleUser = await _mobileGoogleSignIn.signIn();
        if (googleUser == null) {
          return const GoogleLoginResult(success: false, message: '로그인이 취소되었습니다.');
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential);
        return const GoogleLoginResult(success: true);
      }
    } on FirebaseAuthException catch (e) {
      return GoogleLoginResult(
        success: false,
        message: _firebaseAuthMessage(e.code),
      );
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('client_id') || msg.contains('clientId')) {
        return const GoogleLoginResult(
          success: false,
          message: '웹용 Google 클라이언트 ID가 설정되지 않았습니다. docs/FIREBASE_SETUP.md 참고.',
        );
      }
      return GoogleLoginResult(
        success: false,
        message: msg.length > 80 ? '로그인에 실패했습니다.' : msg,
      );
    }
  }

  /// 구글 쪽 로그아웃 (모바일에서 GoogleSignIn 세션 정리용, 웹은 Firebase signOut만 해도 됨)
  static Future<void> signOut() async {
    if (!kIsWeb && _googleSignIn != null) {
      await _googleSignIn!.signOut();
    }
  }

  static String _firebaseAuthMessage(String code) {
    switch (code) {
      case 'popup-closed-by-user':
        return '로그인 창이 닫혔습니다.';
      case 'popup-blocked':
        return '팝업이 차단되었습니다. 브라우저에서 팝업을 허용해 주세요.';
      case 'invalid-credential':
        return '인증 정보가 올바르지 않습니다.';
      default:
        return '로그인에 실패했습니다. ($code)';
    }
  }
}
