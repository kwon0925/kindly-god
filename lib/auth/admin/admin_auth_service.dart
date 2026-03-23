import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/user_profile_repository.dart';

class AdminAuthResult {
  final bool success;
  final String? message;

  const AdminAuthResult({required this.success, this.message});
}

/// 운영자(어드민) 전환 전용 인증 서비스
class AdminAuthService {
  AdminAuthService._();

  static Future<AdminAuthResult> signInAsAdmin() async {
    final auth = FirebaseAuth.instance;
    try {
      // 테스트 계정처럼 즉시 사용 가능하도록 기존 세션을 정리 후 익명 로그인한다.
      if (auth.currentUser != null) {
        await auth.signOut();
      }
      final cred = await auth.signInAnonymously();
      final user = cred.user;
      if (user == null) {
        return const AdminAuthResult(success: false, message: '어드민 로그인에 실패했습니다.');
      }
      await UserProfileRepository.grantAdminRole(uid: user.uid, email: user.email);
      return const AdminAuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operation-not-allowed') {
        return const AdminAuthResult(
          success: false,
          message: 'Firebase Auth에서 익명 로그인이 비활성화되어 있습니다. 콘솔 > Authentication > Sign-in method > Anonymous를 활성화해 주세요.',
        );
      }
      return AdminAuthResult(
        success: false,
        message: e.message ?? '어드민 로그인에 실패했습니다. (${e.code})',
      );
    } catch (_) {
      return const AdminAuthResult(success: false, message: '어드민 로그인에 실패했습니다.');
    }
  }
}
