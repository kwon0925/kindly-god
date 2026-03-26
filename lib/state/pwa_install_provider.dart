import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pwa_install_service.dart';

/// PWA 설치 가능 여부.
/// 앱 시작 시 isInstallable 초기값으로 세팅되고, 설치 완료 후 false로 전환됨.
final pwaInstallableProvider = StateProvider<bool>((ref) {
  return PwaInstallService.isInstallable;
});

/// PWA 설치 프롬프트 실행 액션.
///
/// 사용법 (UI):
///   final install = ref.read(pwaInstallActionProvider);
///   final accepted = await install();
final pwaInstallActionProvider = Provider((ref) {
  return () async {
    final accepted = await PwaInstallService.promptInstall();
    if (accepted) {
      // 설치 수락 → 버튼 숨김
      ref.read(pwaInstallableProvider.notifier).state = false;
    }
    return accepted;
  };
});
