/// 구글 로그인 결과 (다른 화면/기능에서 재사용 가능)
class GoogleLoginResult {
  final bool success;
  final String? message;

  const GoogleLoginResult({required this.success, this.message});
}
