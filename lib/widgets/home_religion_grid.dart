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
/// 로컬(테스트 유저) + 서버(Google 로그인 유저) 포인트 합산하여 표시
class HomeReligionGrid extends ConsumerWidget {
  const HomeReligionGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localState = ref.watch(testPointProvider).state;
    final serverReligionAsync = ref.watch(religionPointsFromServerProvider);
    final serverMap = serverReligionAsync.valueOrNull ?? {};

    // 로컬 + 서버 포인트 합산
    int totalPoints(String id) =>
        localState.getReligionPoints(id) + (serverMap[id] ?? 0);

    final sorted = List<Religion>.from(defaultReligions)
      ..sort((a, b) => totalPoints(b.id).compareTo(totalPoints(a.id)));

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveLayout.isMobile(context)
            ? 2
            : (constraints.maxWidth > 800 ? 4 : 3);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: sorted.length,
          itemBuilder: (context, i) {
            final r = sorted[i];
            final points = totalPoints(r.id);
            return ReligionCard(
              religion: Religion(id: r.id, name: r.name, nameEn: r.nameEn, points: points),
              onTap: () => context.push(AppRoutes.religionDetailPath(r.id)),
            );
          },
        );
      },
    );
  }
}
