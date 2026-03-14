import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/religion.dart';
import '../state/test_point_provider.dart';
import 'responsive_layout.dart';
import 'religion_card.dart';

/// 메인 화면 종교별 응원 포인트 그리드 (테스트 포인트 반영)
class HomeReligionGrid extends ConsumerWidget {
  const HomeReligionGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testPointProvider).state;
    final sorted = List<Religion>.from(defaultReligions)
      ..sort((a, b) => state.getReligionPoints(b.id).compareTo(state.getReligionPoints(a.id)));
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
            final points = state.getReligionPoints(r.id);
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
