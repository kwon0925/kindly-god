import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/firebase_config.dart';
import '../repository/fcm_token_repository.dart';

/// 앱 종료/백그라운드 상태에서 수신되는 메시지 핸들러.
/// Flutter 제약: 반드시 최상위 함수여야 하며, @pragma 어노테이션 필수.
/// 웹에서는 firebase-messaging-sw.js 가 대신 처리하므로 이 함수는 Android/iOS용.
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  debugPrint('[FCM] BG message: ${message.notification?.title}');
}

/// Firebase Cloud Messaging 서비스.
///
/// 사용 흐름:
///   1. main()에서 FcmService.init() 호출
///   2. 온보딩/설정 화면에서 requestPermission() 호출 → 브라우저 권한 다이얼로그
///   3. 권한 허용 후 saveToken() 호출 → Firestore fcm_tokens에 저장
///   4. Auth 변경(로그인/로그아웃/프로필 변경) 시 saveToken() 재호출
class FcmService {
  FcmService._();

  static final _messaging = FirebaseMessaging.instance;

  static const _kDocId = 'fcm_doc_id';
  static const _kToken = 'fcm_token';

  // ── 초기화 ────────────────────────────────────────────────────────────

  /// 앱 시작 시 1회 호출. 백그라운드 핸들러 및 리스너 등록.
  static Future<void> init() async {
    // 웹에서는 onBackgroundMessage가 미구현(UnimplementedError)이라 등록하면 크래시가 발생한다.
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    }
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
    _messaging.onTokenRefresh.listen(_handleTokenRefresh);
  }

  // ── 권한 ──────────────────────────────────────────────────────────────

  /// 알림 권한 요청. 허용 여부 반환.
  static Future<bool> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return _isGranted(settings.authorizationStatus);
    } on MissingPluginException catch (e) {
      debugPrint('[FCM] requestPermission missing plugin: $e');
      return false;
    } on UnimplementedError catch (e) {
      debugPrint('[FCM] requestPermission unimplemented: $e');
      return false;
    }
  }

  /// 현재 알림 권한 상태 조회.
  static Future<AuthorizationStatus> getPermissionStatus() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus;
    } on MissingPluginException catch (e) {
      debugPrint('[FCM] getPermissionStatus missing plugin: $e');
      return AuthorizationStatus.denied;
    } on UnimplementedError catch (e) {
      debugPrint('[FCM] getPermissionStatus unimplemented: $e');
      return AuthorizationStatus.denied;
    }
  }

  // ── 토큰 관리 ─────────────────────────────────────────────────────────

  /// FCM 토큰 발급 및 Firestore 저장.
  /// 권한이 없으면 조용히 반환. 기존 토큰과 동일하면 사용자 정보만 갱신.
  static Future<void> saveToken({
    String? userId,
    String? religionId,
    String? countryId,
    String languageCode = 'ko',
  }) async {
    try {
      final status = await getPermissionStatus();
      if (!_isGranted(status)) return;

      final token = await _messaging.getToken(
        vapidKey: kIsWeb ? FirebaseConfig.vapidKey : null,
      );
      if (token == null) return;

      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_kToken);
      final savedDocId = prefs.getString(_kDocId);

      if (savedToken == token && savedDocId != null) {
        // 토큰 동일 → 사용자 정보만 업데이트
        await FcmTokenRepository.updateUserInfo(
          docId: savedDocId,
          userId: userId,
          religionId: religionId,
          countryId: countryId,
          languageCode: languageCode,
        );
        return;
      }

      // 새 토큰 → Firestore에 새 문서 저장
      final newDocId = await FcmTokenRepository.saveToken(
        token: token,
        userId: userId,
        religionId: religionId,
        countryId: countryId,
        languageCode: languageCode,
      );
      await prefs.setString(_kToken, token);
      await prefs.setString(_kDocId, newDocId);

      // 기존 토큰 문서 정리
      if (savedDocId != null && savedDocId != newDocId) {
        await FcmTokenRepository.deleteToken(savedDocId);
      }
    } catch (e) {
      debugPrint('[FCM] saveToken error: $e');
    }
  }

  /// 현재 토큰 삭제 (알림 비활성화 또는 앱 초기화 시).
  static Future<void> deleteCurrentToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final docId = prefs.getString(_kDocId);
      if (docId != null) {
        await FcmTokenRepository.deleteToken(docId);
        await prefs.remove(_kDocId);
        await prefs.remove(_kToken);
      }
      await _messaging.deleteToken();
    } catch (e) {
      debugPrint('[FCM] deleteCurrentToken error: $e');
    }
  }

  // ── 내부 핸들러 ───────────────────────────────────────────────────────

  static bool _isGranted(AuthorizationStatus status) =>
      status == AuthorizationStatus.authorized ||
      status == AuthorizationStatus.provisional;

  /// FCM 토큰이 서버에서 갱신됐을 때 Firestore 동기화.
  static Future<void> _handleTokenRefresh(String newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final docId = prefs.getString(_kDocId);
      if (docId == null) return;

      await FcmTokenRepository.updateToken(docId: docId, token: newToken);
      await prefs.setString(_kToken, newToken);
    } catch (e) {
      debugPrint('[FCM] tokenRefresh error: $e');
    }
  }

  /// 앱이 열려있을 때(포그라운드) 메시지 수신.
  /// 웹은 브라우저가 자동으로 알림을 띄우지 않으므로 여기서 처리 필요.
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[FCM] Foreground: ${message.notification?.title}');
    // TODO: 인앱 스낵바/배너 표시 필요 시 NotificationOverlay 위젯 구현
    // 예: GlobalKey<NavigatorState>를 통해 SnackBar 표시
  }

  /// 알림 탭해서 앱이 열렸을 때.
  static void _handleMessageOpened(RemoteMessage message) {
    debugPrint('[FCM] Opened from notification: ${message.data}');
    // TODO: message.data['route'] 등으로 특정 화면 이동 시 GoRouter 연동
    // 예: appRouter.go(message.data['route'] ?? '/');
  }
}
