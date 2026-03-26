import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/fcm_provider.dart';

/// 알림 권한 유도 배너.
///
/// 동작 흐름:
///   1. 홈 화면 진입 2초 후 자동 표시 (권한 미허용 상태)
///   2. "허용" 버튼 → 브라우저 기본 권한 다이얼로그 표시
///   3. "나중에" or 닫기 클릭 시 현재 세션에서만 숨김
class NotificationPermissionBanner extends ConsumerStatefulWidget {
  const NotificationPermissionBanner({super.key});

  @override
  ConsumerState<NotificationPermissionBanner> createState() =>
      _NotificationPermissionBannerState();
}

class _NotificationPermissionBannerState
    extends ConsumerState<NotificationPermissionBanner> {
  bool _visible = false;
  bool _dismissedForSession = false;

  @override
  void initState() {
    super.initState();
    _scheduleCheck();
  }

  Future<void> _scheduleCheck() async {
    // 2초 대기 후 표시 여부 결정 (앱 첫 화면 로드 충격 방지)
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final permission = ref.read(notificationPermissionProvider);
    // 이미 허용된 경우는 표시 안 함
    if (permission == AuthorizationStatus.authorized ||
        permission == AuthorizationStatus.provisional) {
      return;
    }

    if (mounted) setState(() => _visible = true);
  }

  Future<void> _onAllow() async {
    _dismiss();
    final request = ref.read(requestNotificationPermissionProvider);
    await request();
  }

  Future<void> _onLater() async {
    _dismiss();
  }

  void _dismiss() {
    if (mounted) {
      setState(() {
        _visible = false;
        _dismissedForSession = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final permission = ref.watch(notificationPermissionProvider);
    if (!_visible || _dismissedForSession) return const SizedBox.shrink();
    if (permission == AuthorizationStatus.authorized ||
        permission == AuthorizationStatus.provisional) {
      return const SizedBox.shrink();
    }

    final isDenied = permission == AuthorizationStatus.denied;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications_active_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '종교 순위 알림 받기',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  isDenied
                      ? '브라우저에서 알림이 차단되어 있습니다.\n주소창 아이콘 또는 사이트 설정에서 알림을 허용해 주세요.'
                      : '1위가 바뀔 때마다 실시간으로 알려드립니다.\n매일 오전 9시 랭킹 요약도 받아보세요.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FilledButton(
                      onPressed: isDenied ? _onLater : _onAllow,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: Text(isDenied ? '설정에서 허용' : '🔔 알림 허용'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _onLater,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text('나중에'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _onLater,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.close,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
