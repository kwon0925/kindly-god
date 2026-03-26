import 'package:flutter/foundation.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// 번역 결과 상태
enum TranslationStatus {
  idle,         // 초기 상태
  loading,      // 번역 중
  success,      // 번역 완료
  error,        // 오류
  unsupported,  // 플랫폼 미지원 (웹)
}

/// 번역 결과 값 객체
class TranslationResult {
  final TranslationStatus status;
  final String? translatedText;
  final String? errorMessage;

  const TranslationResult({
    required this.status,
    this.translatedText,
    this.errorMessage,
  });

  bool get isSuccess => status == TranslationStatus.success;
  bool get isLoading => status == TranslationStatus.loading;
  bool get isUnsupported => status == TranslationStatus.unsupported;

  static const idle = TranslationResult(status: TranslationStatus.idle);
  static const unsupported = TranslationResult(status: TranslationStatus.unsupported);
}

/// 온디바이스 번역 서비스 (싱글톤)
///
/// 현재 지원:
///   - 웹: 미지원 (앱 설치 안내)
///   - 모바일: google_mlkit_translation 연동 준비 완료 (추후 구현)
///
/// 확장 방법:
///   1. pubspec.yaml에 `google_mlkit_translation` 추가
///   2. [_translateWithMlKit] 메서드 구현
///   3. kIsWeb 분기에서 모바일 경로 활성화
class TranslationService {
  TranslationService._();
  static final TranslationService instance = TranslationService._();
  final OnDeviceTranslatorModelManager _modelManager =
      OnDeviceTranslatorModelManager();
  final Set<String> _ensuredModels = <String>{};

  /// 현재 플랫폼에서 온디바이스 번역이 가능한지 여부
  bool get isAvailable => !kIsWeb;

  /// 텍스트 번역
  ///
  /// [text]        번역할 원문
  /// [targetCode]  목표 언어 코드 (예: 'en', 'ja')
  /// [sourceCode]  원문 언어 코드 (기본값: 'ko')
  Future<TranslationResult> translate({
    required String text,
    required String targetCode,
    String sourceCode = 'ko',
  }) async {
    if (kIsWeb) {
      return TranslationResult.unsupported;
    }
    if (sourceCode == targetCode) {
      return TranslationResult(
        status: TranslationStatus.success,
        translatedText: text,
      );
    }

    try {
      final sourceLang = _toTranslateLanguage(sourceCode);
      final targetLang = _toTranslateLanguage(targetCode);
      if (sourceLang == null || targetLang == null) {
        return const TranslationResult(
          status: TranslationStatus.error,
          errorMessage: '지원하지 않는 언어입니다.',
        );
      }

      await _ensureModel(sourceLang);
      await _ensureModel(targetLang);

      final translator = OnDeviceTranslator(
        sourceLanguage: sourceLang,
        targetLanguage: targetLang,
      );
      try {
        final translated = await translator.translateText(text);
        return TranslationResult(
          status: TranslationStatus.success,
          translatedText: translated,
        );
      } finally {
        await translator.close();
      }
    } catch (e) {
      return TranslationResult(
        status: TranslationStatus.error,
        errorMessage: '번역 실패: $e',
      );
    }
  }

  Future<void> _ensureModel(TranslateLanguage lang) async {
    if (_ensuredModels.contains(lang.bcpCode)) return;
    final downloaded = await _modelManager.isModelDownloaded(lang.bcpCode);
    if (!downloaded) {
      await _modelManager.downloadModel(lang.bcpCode);
    }
    _ensuredModels.add(lang.bcpCode);
  }

  TranslateLanguage? _toTranslateLanguage(String code) {
    switch (code.toLowerCase()) {
      case 'ko':
        return TranslateLanguage.korean;
      case 'en':
        return TranslateLanguage.english;
      case 'zh':
        return TranslateLanguage.chinese;
      case 'ja':
        return TranslateLanguage.japanese;
      case 'es':
        return TranslateLanguage.spanish;
      case 'fr':
        return TranslateLanguage.french;
      case 'de':
        return TranslateLanguage.german;
      case 'ru':
        return TranslateLanguage.russian;
      case 'pt':
        return TranslateLanguage.portuguese;
      case 'ar':
        return TranslateLanguage.arabic;
      default:
        return null;
    }
  }
}
