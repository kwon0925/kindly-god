import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/pwa_install_service.dart';
import '../state/pwa_install_provider.dart';

/// 홈 화면 아이콘 추가 플로우.
///
/// 1) 플랫폼 선택 팝업 표시
/// 2) 안드로이드 선택 시 설치 프롬프트 시도
/// 3) 실패 시 환경별 안내
/// iOS는 안내만 제공(별도 자동 프롬프트는 정책상 불가)
class HomeShortcutFlow {
  HomeShortcutFlow._();

  static Future<void> openPicker(BuildContext context, WidgetRef ref) async {
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('홈 화면 아이콘 추가'),
        content: const Text('사용 중인 기기를 선택해 주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _handleAndroid(context, ref);
            },
            icon: const Icon(Icons.android, size: 18),
            label: const Text('안드로이드'),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _showIosGuide(context);
            },
            icon: const Icon(Icons.phone_iphone, size: 18),
            label: const Text('iPhone'),
          ),
        ],
      ),
    );
  }

  static Future<void> _handleAndroid(BuildContext context, WidgetRef ref) async {
    final install = ref.read(pwaInstallActionProvider);
    final accepted = await install();
    if (!context.mounted) return;

    if (accepted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('홈 화면 아이콘 추가 팝업이 열렸습니다.')));
      return;
    }

    await _showAndroidGuide(context);
  }

  static Future<void> _showAndroidGuide(BuildContext context) async {
    final hint = PwaInstallService.installHint;
    final message = switch (hint) {
      'installed' => '이미 홈 화면에 추가된 상태입니다.',
      'android' => 'Chrome 메뉴(⋮)에서 "홈 화면에 추가"를 눌러 주세요.',
      'inapp' => '인앱 브라우저에서는 제한될 수 있습니다.\nChrome에서 다시 열어 주세요.',
      'ios' => '현재 환경은 iPhone/iPad로 감지됩니다.\nSafari에서 "홈 화면에 추가"를 눌러 주세요.',
      _ => '현재 환경에서 자동 팝업이 제한됩니다.\nChrome 최신 버전에서 다시 시도해 주세요.',
    };

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('안드로이드 안내'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  static Future<void> _showIosGuide(BuildContext context) async {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('iPhone 안내'),
        content: const Text(
          'iPhone은 자동 팝업이 불가합니다.\nSafari 하단 공유 버튼에서 "홈 화면에 추가"를 선택해 주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
