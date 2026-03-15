import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/religion.dart';
import '../state/test_point_provider.dart';
import '../state/user_profile_provider.dart';
import '../widgets/religion_card.dart';
import '../widgets/responsive_layout.dart';

/// 전체 종교 목록 화면 — 포인트 내림차순 정렬, 전체 표시
class AllReligionsScreen extends ConsumerWidget {
  const AllReligionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localState = ref.watch(testPointProvider).state;
    final serverMap =
        ref.watch(religionPointsFromServerProvider).valueOrNull ?? {};

    int totalPoints(String id) =>
        localState.getReligionPoints(id) + (serverMap[id] ?? 0);

    final sorted = List<Religion>.from(defaultReligions)
      ..sort((a, b) => totalPoints(b.id).compareTo(totalPoints(a.id)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('전체 종교'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsivePadding(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = ResponsiveLayout.isMobile(context)
                ? 2
                : (constraints.maxWidth > 800 ? 4 : 3);

            return GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                  religion: Religion(
                      id: r.id, name: r.name, nameEn: r.nameEn, points: points),
                  onTap: () => context.push(AppRoutes.religionDetailPath(r.id)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
