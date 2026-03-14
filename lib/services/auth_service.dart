import 'package:firebase_auth/firebase_auth.dart';

import '../auth/google/google_login_service.dart';

/// 앱 전역 인증 서비스 (Firebase Auth + 구글 로그인 연동)
/// 구글 로그인 구현은 lib/auth/google/ 에서 관리
class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Google로 로그인 (웹: signInWithPopup, 모바일: google_sign_in + credential)
  static Future<AuthResult> signInWithGoogle() async {
    final result = await GoogleLoginService.signIn();
    return AuthResult(
      success: result.success,
      message: result.message,
    );
  }

  /// 로그아웃
  static Future<void> signOut() async {
    await GoogleLoginService.signOut();
    await _auth.signOut();
  }
}

class AuthResult {
  final bool success;
  final String? message;

  AuthResult({required this.success, this.message});
}
