import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Firestore `fcm_tokens` 컬렉션 CRUD.
///
/// 문서 ID는 Firestore 자동 생성 → SharedPreferences에 저장해서 재사용.
/// 비로그인(userId=null)도 저장 가능 — 비로그인 푸시 대상.
///
/// Firestore 보안 규칙 예시(firestore.rules에 추가 필요):
///   match /fcm_tokens/{tokenId} {
///     allow create: if true;  // 비로그인도 생성 허용
///     allow update, delete: if request.auth != null
///       && resource.data.userId == request.auth.uid
///       || resource.data.userId == null;
///     allow read: if false;   // 클라이언트 직접 읽기 차단 (Functions만)
///   }
class FcmTokenRepository {
  FcmTokenRepository._();

  static final _store = FirebaseFirestore.instance;
  static const _collection = 'fcm_tokens';

  /// 새 FCM 토큰 문서 생성. 생성된 문서 ID 반환.
  static Future<String> saveToken({
    required String token,
    String? userId,
    String? religionId,
    String? countryId,
    String languageCode = 'ko',
  }) async {
    final ref = _store.collection(_collection).doc();
    await ref.set({
      'token': token,
      'userId': userId,
      'religionId': religionId,
      'countryId': countryId,
      'languageCode': languageCode,
      'platform': kIsWeb ? 'web' : 'mobile',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  /// 토큰 문자열만 갱신 (FCM onTokenRefresh 시).
  static Future<void> updateToken({
    required String docId,
    required String token,
  }) async {
    await _store.collection(_collection).doc(docId).update({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 사용자 정보 갱신 (로그인·로그아웃·종교/국가 변경 시).
  static Future<void> updateUserInfo({
    required String docId,
    String? userId,
    String? religionId,
    String? countryId,
    String languageCode = 'ko',
  }) async {
    await _store.collection(_collection).doc(docId).update({
      'userId': userId,
      'religionId': religionId,
      'countryId': countryId,
      'languageCode': languageCode,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 토큰 문서 삭제 (알림 비활성화·기기 변경 시).
  static Future<void> deleteToken(String docId) async {
    await _store.collection(_collection).doc(docId).delete();
  }
}
