import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/religion.dart';
import '../state/test_point_provider.dart';
import '../state/user_profile_provider.dart';
import 'responsive_layout.dart';
import 'religion_card.dart';

/// 메인 화면 종교별 응원 포인트 그리드
/// - 포인트 내림차순으로 정렬, 상위 [limit]개만 노출
/// - 나머지는 "전체보기" 버튼으로 /religions 화면에서 확인
class HomeReligionGrid extends ConsumerWidget {
  final int limit;

  const HomeReligionGrid({super.key, this.limit = 8});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localState = ref.watch(testPointProvider).state;
    final serverMap = ref.watch(religionPointsFromServerProvider).valueOrNull ?? {};

    int totalPoints(String id) =>
        localState.getReligionPoints(id) + (serverMap[id] ?? 0);

    final sorted = List<Religion>.from(defaultReligions)
      ..sort((a, b) => totalPoints(b.id).compareTo(totalPoints(a.id)));

    final displayed = sorted.take(limit).toList();
    final hasMore = sorted.length > limit;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveLayout.isMobile(context)
            ? 2
            : (constraints.maxWidth > 800 ? 4 : 3);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: displayed.length,
              itemBuilder: (context, i) {
                final r = displayed[i];
                final points = totalPoints(r.id);
                return ReligionCard(
                  religion:
                      Religion(id: r.id, name: r.name, nameEn: r.nameEn, points: points),
                  onTap: () => context.push(AppRoutes.religionDetailPath(r.id)),
                );
              },
            ),
            if (hasMore) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => context.push(AppRoutes.religions),
                icon: const Icon(Icons.grid_view_rounded, size: 18),
                label: Text(
                  '전체보기 (${sorted.length}개 종교 모두 보기)',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
