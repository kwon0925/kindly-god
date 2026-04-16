import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/pwa_install_service.dart';
import '../state/pwa_install_provider.dart';

/// PWA 홈 화면 추가 유도 배너.
///
/// 브라우저가 추가 프롬프트를 지원할 때만 자동으로 표시되며,
/// 추가 완료 또는 닫기 버튼 클릭 시 사라집니다.
///
/// 사용법: 화면 body 최하단 또는 Scaffold.bottomSheet 영역에 배치.
///   PwaInstallBanner()
class PwaInstallBanner extends ConsumerWidget {
  const PwaInstallBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installable = ref.watch(pwaInstallableProvider);
    if (!installable) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B5E20),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.download_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kindly-God 홈 화면 추가',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '바탕화면 아이콘으로 더 빠르게 이용할 수 있어요',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () async {
                final install = ref.read(pwaInstallActionProvider);
                final accepted = await install();
                if (!context.mounted || accepted) return;

                final hint = PwaInstallService.installHint;
                final message = switch (hint) {
                  'installed' => '이미 홈 화면에 추가된 상태입니다.',
                  'ios' => 'iPhone/iPad는 Safari의 공유 버튼에서\n"홈 화면에 추가"를 선택해 주세요.',
                  'android' => '브라우저 메뉴(⋮)에서\n"홈 화면에 추가"를 선택해 주세요.',
                  'inapp' => '인앱 브라우저에서는 홈 화면 추가가 제한됩니다.\nChrome/Safari에서 다시 열어 주세요.',
                  _ => '현재 브라우저에서 홈 화면 추가가 제한될 수 있습니다.\nChrome/Safari 최신 버전으로 다시 시도해 주세요.',
                };

                await showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('홈 화면 추가 안내'),
                    content: Text(message),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('추가', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 4),
            // 닫기
            GestureDetector(
              onTap: () => ref.read(pwaInstallableProvider.notifier).state = false,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, color: Colors.white60, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
