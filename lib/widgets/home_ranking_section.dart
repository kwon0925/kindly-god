import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/ranking.dart';
import '../models/religion.dart';
import '../models/country.dart';
import '../repository/user_profile_repository.dart';
import '../state/user_profile_provider.dart';
import 'responsive_layout.dart';
import 'religion_card.dart';
import 'country_card.dart';
import 'rank_medal_overlay.dart';

int _daysSinceEpochUtc() {
  final now = DateTime.now().toUtc();
  return DateTime.utc(now.year, now.month, now.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
}

int _seedFor(RankingPeriod period, RankingType type) {
  // 같은 날에는 동점 셔플이 고정되어 UI가 깜빡이지 않도록 일 단위 시드 사용.
  return _daysSinceEpochUtc() * 31 + period.index * 7 + type.index;
}

List<T> _sortWithRandomTies<T>(
  List<T> items,
  int Function(T) pointsOf, {
  required int seed,
}) {
  final byPoints = <int, List<T>>{};
  for (final it in items) {
    (byPoints[pointsOf(it)] ??= <T>[]).add(it);
  }
  final keys = byPoints.keys.toList()..sort((a, b) => b.compareTo(a));
  final rand = Random(seed);
  final out = <T>[];
  for (final k in keys) {
    final group = byPoints[k]!;
    if (group.length > 1) {
      group.shuffle(rand);
    }
    out.addAll(group);
  }
  return out;
}

/// 메인 화면 통합 섹션: 종교별 응원 포인트 + 랭킹
/// - 기간: 오늘 / 이번주 / 이번달 / 전체
/// - 타입: 종교 / 계정 / 국가
/// - 콘텐츠: 포인트 순 정렬, 1·2·3위 카드에 순위+메달 오버레이
/// - 기간별 데이터는 추후 백엔드 연동 시 반영 가능 (현재는 전체 누적만 사용)
class HomeRankingSection extends ConsumerStatefulWidget {
  const HomeRankingSection({super.key});

  @override
  ConsumerState<HomeRankingSection> createState() => _HomeRankingSectionState();
}

class _HomeRankingSectionState extends ConsumerState<HomeRankingSection> {
  RankingPeriod _period = RankingPeriod.today;
  RankingType _type = RankingType.religion;

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(accountRankingByPeriodProvider(_period));
    final religionAsync = ref.watch(religionPointsByPeriodProvider(_period));
    final countryAsync = ref.watch(countryPointsByPeriodProvider(_period));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '종교별 응원 포인트',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _PeriodChips(
              value: _period,
              onChanged: (p) => setState(() => _period = p),
            ),
            const SizedBox(height: 8),
            _TypeChips(
              value: _type,
              onChanged: (t) => setState(() => _type = t),
            ),
            const SizedBox(height: 16),
            _ContentArea(
              period: _period,
              type: _type,
              accountAsync: accountAsync,
              religionAsync: religionAsync,
              countryAsync: countryAsync,
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodChips extends StatelessWidget {
  final RankingPeriod value;
  final ValueChanged<RankingPeriod> onChanged;

  const _PeriodChips({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: RankingPeriod.values.map((p) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(rankingPeriodLabels[p] ?? ''),
              selected: value == p,
              onSelected: (_) => onChanged(p),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TypeChips extends StatelessWidget {
  final RankingType value;
  final ValueChanged<RankingType> onChanged;

  const _TypeChips({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: RankingType.values.map((t) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(rankingTypeLabels[t] ?? ''),
              selected: value == t,
              onSelected: (_) => onChanged(t),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  final RankingPeriod period;
  final RankingType type;
  final AsyncValue<List<UserProfile>> accountAsync;
  final AsyncValue<Map<String, int>> religionAsync;
  final AsyncValue<Map<String, int>> countryAsync;

  const _ContentArea({
    required this.period,
    required this.type,
    required this.accountAsync,
    required this.religionAsync,
    required this.countryAsync,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case RankingType.religion:
        return _ReligionGrid(
          period: period,
          religionAsync: religionAsync,
        );
      case RankingType.account:
        return _AccountList(
          period: period,
          accountAsync: accountAsync,
        );
      case RankingType.country:
        return _CountryGrid(
          period: period,
          countryAsync: countryAsync,
        );
    }
  }
}

class _ReligionGrid extends StatelessWidget {
  final RankingPeriod period;
  final AsyncValue<Map<String, int>> religionAsync;

  const _ReligionGrid({
    required this.period,
    required this.religionAsync,
  });

  @override
  Widget build(BuildContext context) {
    final serverMap = religionAsync.valueOrNull ?? {};
    final items = defaultReligions
        .map((r) {
          final serverPts = serverMap[r.id] ?? 0;
          return Religion(
            id: r.id,
            name: r.name,
            nameEn: r.nameEn,
            points: serverPts,
          );
        })
        .toList();
    final sorted = _sortWithRandomTies(
      items,
      (x) => x.points,
      seed: _seedFor(period, RankingType.religion),
    );
    final displayed = sorted.take(8).toList();
    final hasMore = sorted.length > 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = ResponsiveLayout.isMobile(context)
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
                final rank = i + 1;
                return ReligionCard(
                  religion: r,
                  rank: rank <= 3 ? rank : null,
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
                  '전체보기 (${sorted.length}개 종교)',
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

/// 계정 랭킹 한 줄: 아이디, 포인트, (선택) 국가·종교
class _AccountRankItem {
  final String id;
  final String name;
  final int points;
  final String? religionId;
  final String? countryId;

  _AccountRankItem({
    required this.id,
    required this.name,
    required this.points,
    this.religionId,
    this.countryId,
  });
}

class _AccountList extends StatelessWidget {
  final RankingPeriod period;
  final AsyncValue<List<UserProfile>> accountAsync;

  const _AccountList({
    required this.period,
    required this.accountAsync,
  });

  static String _religionName(String? id) {
    if (id == null || id.isEmpty) return '';
    final r = defaultReligions.cast<Religion?>().firstWhere(
          (x) => x?.id == id,
          orElse: () => null,
        );
    return r?.name ?? '';
  }

  static String _countryName(String? id) {
    if (id == null || id.isEmpty) return '';
    final c = defaultCountries.cast<Country?>().firstWhere(
          (x) => x?.id == id,
          orElse: () => null,
        );
    return c?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final serverList = accountAsync.valueOrNull ?? <UserProfile>[];
    final combined = <_AccountRankItem>[
      ...serverList.map((p) => _AccountRankItem(
            id: p.uid,
            name: p.displayName ?? p.uid,
            points: p.points,
            religionId: p.religionId,
            countryId: p.countryId,
          )),
    ]..sort((a, b) => b.points.compareTo(a.points));
    final displayed = combined.take(10).toList();

    if (displayed.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          '응원하기에서 포인트를 쌓아 보세요',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
      );
    }

    final theme = Theme.of(context);
    return Column(
      children: displayed.asMap().entries.map((e) {
        final rank = e.key + 1;
        final item = e.value;
        final religionName = _religionName(item.religionId);
        final countryName = _countryName(item.countryId);
        final hasSub = religionName.isNotEmpty || countryName.isNotEmpty;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Card(
            child: ListTile(
              leading: rank <= 3
                  ? RankMedalOverlay(rank: rank)
                  : SizedBox(
                      width: 48,
                      child: Center(
                        child: Text(
                          '$rank',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
              title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: hasSub
                  ? Text(
                      [if (countryName.isNotEmpty) countryName, if (religionName.isNotEmpty) religionName].join(' · '),
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: Text('${item.points} P', style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CountryGrid extends StatelessWidget {
  final RankingPeriod period;
  final AsyncValue<Map<String, int>> countryAsync;

  const _CountryGrid({
    required this.period,
    required this.countryAsync,
  });

  @override
  Widget build(BuildContext context) {
    final serverMap = countryAsync.valueOrNull ?? {};
    final items = defaultCountries
        .map((c) {
          final serverPts = serverMap[c.id] ?? 0;
          return Country(
            id: c.id,
            name: c.name,
            nameEn: c.nameEn,
            points: serverPts,
          );
        })
        .toList();
    final sorted = _sortWithRandomTies(
      items,
      (x) => x.points,
      seed: _seedFor(period, RankingType.country),
    );
    final displayed = sorted.take(8).toList();
    final hasMore = sorted.length > 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = ResponsiveLayout.isMobile(context)
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
                final c = displayed[i];
                final rank = i + 1;
                return CountryCard(
                  country: c,
                  rank: rank <= 3 ? rank : null,
                );
              },
            ),
            if (hasMore) ...[
              const SizedBox(height: 8),
              Text(
                '총 ${sorted.length}개 국가',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.end,
              ),
            ],
          ],
        );
      },
    );
  }
}
