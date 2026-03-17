import 'dart:convert';

import 'package:flutter/services.dart';

/// `assets/images/flags/` 아래의 국기 에셋을 AssetManifest에서 동적으로 로드.
/// 파일명 규칙: `..._<code>.webp` (예: imgi_120_kr.webp → code=kr)
class FlagAssetsService {
  FlagAssetsService._();

  static final RegExp _codeRegex = RegExp(r'_([a-z]{2})\.webp$', caseSensitive: false);

  /// 반환: code(소문자 2글자) → assetPath
  static Future<Map<String, String>> loadFlagAssetsByCode() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final manifest = json.decode(manifestJson) as Map<String, dynamic>;

    final result = <String, String>{};
    for (final key in manifest.keys) {
      if (!key.startsWith('assets/images/flags/')) continue;
      if (!key.toLowerCase().endsWith('.webp')) continue;
      final m = _codeRegex.firstMatch(key.toLowerCase());
      if (m == null) continue;
      final code = m.group(1);
      if (code == null || code.length != 2) continue;
      // 중복 code면 먼저 발견된 것을 유지
      result.putIfAbsent(code, () => key);
    }
    return result;
  }
}

