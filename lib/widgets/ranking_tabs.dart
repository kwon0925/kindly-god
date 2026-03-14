import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking.dart';
import '../repository/user_profile_repository.dart';
import '../state/test_point_provider.dart';
import '../state/user_profile_provider.dart';

class RankingTabs extends ConsumerStatefulWidget {
  const RankingTabs({super.key});

  @override
  ConsumerState<RankingTabs> createState() => _RankingTabsState();
}

class _RankingTabsState extends ConsumerState<RankingTabs> {
  RankingPeriod _period = RankingPeriod.today;
  RankingType _type = RankingType.religion;

  static const periodLabels = {
    RankingPeriod.today: '오늘',
    RankingPeriod.week: '이번주',
    RankingPeriod.month: '이번달',
    RankingPeriod.year: '1년',
  };

  static const typeLabels = {
    RankingType.religion: '종교별',
    RankingType.account: '계정별',
    RankingType.country: '국가별',
  };

  @override
  Widget build(BuildContext context) {
    ref.watch(testPointProvider);
    final accountRankingAsync = ref.watch(accountRankingFromServerProvider);
    final list = _rankingList(accountRankingAsync);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: RankingPeriod.values.map((p) {
                  final selected = _period == p;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(periodLabels[p]!),
                      selected: selected,
                      onSelected: (_) => setState(() => _period = p),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: RankingType.values.map((t) {
                  final selected = _type == t;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(typeLabels[t]!),
                      selected: selected,
                      onSelected: (_) => setState(() => _type = t),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            if (_type == RankingType.account && accountRankingAsync.isLoading && list.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Center(child: CircularProgressIndicator())),
            if (!(_type == RankingType.account && accountRankingAsync.isLoading && list.isEmpty)) ...[
              ...list.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 36,
                      child: _RankCrown(rank: item.rank),
                    ),
                    Expanded(child: Text(item.name)),
                    Text('${item.points} P', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '응원하기에서 포인트를 쌓아 보세요',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  List<({String id, String name, int points, int rank})> _rankingList(AsyncValue<List<UserProfile>> accountRankingAsync) {
    final notifier = ref.read(testPointProvider);
    switch (_type) {
      case RankingType.religion:
        return notifier.getReligionRanking();
      case RankingType.account: {
        final serverList = accountRankingAsync.valueOrNull ?? <UserProfile>[];
        final localList = notifier.getAccountRanking();
        final combined = <({String id, String name, int points})>[
          ...serverList.map((p) => (id: p.uid, name: p.displayName ?? p.uid, points: p.points)),
          ...localList.map((e) => (id: e.id, name: e.name, points: e.points)),
        ];
        combined.sort((a, b) => b.points.compareTo(a.points));
        return combined.take(5).toList().asMap().entries.map((e) => (id: e.value.id, name: e.value.name, points: e.value.points, rank: e.key + 1)).toList();
      }
      case RankingType.country:
        return notifier.getCountryRanking();
    }
  }
}

/// 1·2·3위 금·은·동 왕관 아이콘 (화려하게)
class _RankCrown extends StatelessWidget {
  final int rank;

  const _RankCrown({required this.rank});

  static const _gold = Color(0xFFFFD700);
  static const _silver = Color(0xFFC0C0C0);
  static const _bronze = Color(0xFFCD7F32);

  @override
  Widget build(BuildContext context) {
    if (rank > 3) {
      return Text(
        '$rank',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }
    final color = rank == 1 ? _gold : rank == 2 ? _silver : _bronze;
    final size = rank == 1 ? 28.0 : 24.0;
    return Container(
      width: size + 8,
      height: size + 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            Color.lerp(color, Colors.black, 0.25)!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: rank == 1 ? 8 : 5,
            spreadRadius: 0,
          ),
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '👑',
          style: TextStyle(fontSize: size - 4, height: 1.0),
        ),
      ),
    );
  }
}
