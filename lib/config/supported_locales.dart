import 'package:flutter/material.dart';

/// 앱이 지원하는 언어 목록. ARB 파일 추가 시 이 목록도 함께 수정.
class AppLocaleInfo {
  final String code;
  final String nativeName;
  final String flagEmoji;

  const AppLocaleInfo({
    required this.code,
    required this.nativeName,
    required this.flagEmoji,
  });

  Locale get locale => Locale(code);
}

const List<AppLocaleInfo> kSupportedLocales = [
  AppLocaleInfo(code: 'ko', nativeName: '한국어', flagEmoji: '🇰🇷'),
  AppLocaleInfo(code: 'en', nativeName: 'English', flagEmoji: '🇺🇸'),
  AppLocaleInfo(code: 'zh', nativeName: '中文', flagEmoji: '🇨🇳'),
  AppLocaleInfo(code: 'ja', nativeName: '日本語', flagEmoji: '🇯🇵'),
  AppLocaleInfo(code: 'es', nativeName: 'Español', flagEmoji: '🇪🇸'),
  AppLocaleInfo(code: 'fr', nativeName: 'Français', flagEmoji: '🇫🇷'),
  AppLocaleInfo(code: 'de', nativeName: 'Deutsch', flagEmoji: '🇩🇪'),
  AppLocaleInfo(code: 'ru', nativeName: 'Русский', flagEmoji: '🇷🇺'),
  AppLocaleInfo(code: 'pt', nativeName: 'Português', flagEmoji: '🇧🇷'),
  AppLocaleInfo(code: 'ar', nativeName: 'العربية', flagEmoji: '🇸🇦'),
];

/// 언어 코드로 AppLocaleInfo 조회 (없으면 한국어 반환)
AppLocaleInfo localeInfoByCode(String code) {
  return kSupportedLocales.firstWhere(
    (l) => l.code == code,
    orElse: () => kSupportedLocales.first,
  );
}
