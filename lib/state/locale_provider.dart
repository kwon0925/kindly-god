import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../repository/user_profile_repository.dart';

const _kLocaleKey = 'app_locale_code';

/// 앱 전체 언어 상태 관리 (SharedPreferences 영속 + Firestore 동기화)
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ko')) {
    _loadFromPrefs();
  }

  /// 앱 시작 시 저장된 언어 코드 복원
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLocaleKey);
    if (code != null && mounted) {
      state = Locale(code);
    }
  }

  /// 사용자가 언어를 직접 선택했을 때 (항상 허용)
  Future<void> setLocale(Locale locale) async {
    if (state.languageCode == locale.languageCode) return;
    state = locale;

    // SharedPreferences 즉시 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);

    // 로그인 상태면 Firestore에도 반영
    final uid = AuthService.currentUser?.uid;
    if (uid != null) {
      await UserProfileRepository.updateLanguageCode(uid, locale.languageCode);
    }
  }

  /// 로그인 후 Firestore 프로필에 저장된 언어가 있을 때 동기화
  /// - SharedPreferences에 값이 없는 경우(첫 로그인)에만 적용
  Future<void> syncFromProfile(String? languageCode) async {
    if (languageCode == null || languageCode.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_kLocaleKey) && mounted) {
      state = Locale(languageCode);
      await prefs.setString(_kLocaleKey, languageCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
