import 'dart:js_interop';
import 'package:flutter/foundation.dart';

// JS 전역 함수 바인딩 (web/index.html 에서 등록됨)
@JS('isPwaInstallable')
external bool _jsIsInstallable();

@JS('promptPwaInstall')
external JSPromise<JSBoolean> _jsPromptInstall();

@JS('getPwaInstallHint')
external JSString _jsGetPwaInstallHint();

/// PWA 홈 화면 설치 프롬프트 서비스.
///
/// 브라우저가 beforeinstallprompt 이벤트를 지원할 때만 동작하며,
/// 이미 설치됐거나 iOS Safari(미지원) 환경에서는 isInstallable == false.
class PwaInstallService {
  PwaInstallService._();

  /// 설치 미완료 사유 가이드 코드.
  /// installed | ios | android | inapp | unknown
  static String get installHint {
    if (!kIsWeb) return 'unknown';
    try {
      return _jsGetPwaInstallHint().toDart;
    } catch (_) {
      return 'unknown';
    }
  }

  /// 현재 브라우저가 PWA 설치 프롬프트를 띄울 수 있는 상태인지 확인.
  static bool get isInstallable {
    if (!kIsWeb) return false;
    try {
      return _jsIsInstallable();
    } catch (_) {
      return false;
    }
  }

  /// 브라우저 설치 다이얼로그 표시. 사용자가 수락하면 true 반환.
  static Future<bool> promptInstall() async {
    if (!kIsWeb) return false;
    try {
      final result = await _jsPromptInstall().toDart;
      return result.toDart;
    } catch (_) {
      return false;
    }
  }
}
