/// 계정 팝업에서 사용하는 문구 (유지보수 시 한 곳만 수정)
class AccountDialogStrings {
  AccountDialogStrings._();

  static const String titleAccount = '계정';
  static const String lockedWarning =
      '한 번 설정된 아이디·종교·국가는 변경할 수 없습니다.';
  static const String beforeSaveHint =
      '종교·국가 선택 후 확인하면 이후 변경할 수 없습니다.';
  static const String confirmButtonLabel = '확인';
  static const String confirmDialogTitle = '최종 확인';
  static const String confirmDialogMessage =
      '설정한 아이디·종교·국가로 진행할까요?\n확인 후에는 수정할 수 없습니다.';
  static const String confirmDialogCancel = '취소';
  static const String confirmDialogConfirm = '확인';
  static const String saveCompleteMessage =
      '설정이 완료되었습니다. 아이디·종교·국가는 변경할 수 없습니다.';

  /// 로그인 전용 팝업 (구글 로그인 버튼만)
  static const String loginOnlyTitle = '로그인';
  static const String googleLoginButton = 'Google로 로그인';
  static const String googleLoginLoading = '로그인 중...';

  /// 비로그인 상태에서 계정 팝업이 열렸을 때(예: 직접 호출)
  static const String loginRequiredTitle = '계정';
  static const String loginRequiredMessage = '로그인이 필요합니다.';
}
