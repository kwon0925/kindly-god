import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/fcm_service.dart';
import 'user_profile_provider.dart';

/// 현재 알림 권한 상태. null = 아직 확인 안 함.
final notificationPermissionProvider =
    StateProvider<AuthorizationStatus?>((ref) => null);

/// 앱 시작 시 현재 권한 상태를 읽어 notificationPermissionProvider에 채움.
/// KindlyGodApp.build() 에서 ref.watch 해두면 자동 실행.
final notificationPermissionLoaderProvider = FutureProvider<void>((ref) async {
  final status = await FcmService.getPermissionStatus();
  ref.read(notificationPermissionProvider.notifier).state = status;
});

/// 알림 권한 요청 + 토큰 저장 액션.
///
/// 사용법 (UI):
///   final request = ref.read(requestNotificationPermissionProvider);
///   final granted = await request();
final requestNotificationPermissionProvider = Provider((ref) {
  return () async {
    final granted = await FcmService.requestPermission();
    ref.read(notificationPermissionProvider.notifier).state =
        granted ? AuthorizationStatus.authorized : AuthorizationStatus.denied;

    if (granted) {
      final profile = ref.read(currentUserProfileProvider).valueOrNull;
      await FcmService.saveToken(
        userId: profile?.uid,
        religionId: profile?.religionId,
        countryId: profile?.countryId,
        languageCode: profile?.languageCode ?? 'ko',
      );
    }
    return granted;
  };
});

/// Auth 상태 / 프로필 변경 시 FCM 토큰 자동 갱신.
///
/// KindlyGodApp.build()에서 ref.watch(fcmAuthSyncProvider)로 활성화.
/// 앱 전체 생명주기 동안 유지되어야 하므로 autoDispose 없이 선언.
final fcmAuthSyncProvider = Provider<void>((ref) {
  // 프로필 변경 감지 (로그인 후 종교·국가 설정 포함)
  ref.listen(currentUserProfileProvider, (_, next) async {
    final profile = next.valueOrNull;
    if (profile == null) return;
    await FcmService.saveToken(
      userId: profile.uid,
      religionId: profile.religionId,
      countryId: profile.countryId,
      languageCode: profile.languageCode ?? 'ko',
    );
  });

  // 로그아웃 감지 (auth user가 null이 될 때 → 비로그인 상태로 토큰 갱신)
  ref.listen(authUserProvider, (_, next) async {
    if (next.valueOrNull == null) {
      await FcmService.saveToken();
    }
  });
});
