import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking.dart';
import '../models/religion.dart';
import '../models/country.dart';
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

  String _periodLabel(BuildContext context, RankingPeriod p) {
    final l10n = AppLocalizations.of(context);
    switch (p) {
      case RankingPeriod.today:
        return l10n.today;
      case RankingPeriod.week:
        return l10n.thisWeek;
      case RankingPeriod.month:
        return l10n.thisMonth;
      case RankingPeriod.all:
        return l10n.allTime;
    }
  }

  String _typeLabel(BuildContext context, RankingType t) {
    final l10n = AppLocalizations.of(context);
    switch (t) {
      case RankingType.religion:
        return l10n.religionType;
      case RankingType.account:
        return l10n.accountType;
      case RankingType.country:
        return l10n.countryType;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(testPointProvider);
    final accountAsync = ref.watch(accountRankingFromServerProvider);
    final religionAsync = ref.watch(religionPointsFromServerProvider);
    final countryAsync = ref.watch(countryPointsFromServerProvider);

    final isLoading = switch (_type) {
      RankingType.account => accountAsync.isLoading,
      RankingType.religion => religionAsync.isLoading,
      RankingType.country => countryAsync.isLoading,
    };

    final list = _rankingList(
      accountAsync: accountAsync,
      religionAsync: religionAsync,
      countryAsync: countryAsync,
    );

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
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_periodLabel(context, p)),
                      selected: _period == p,
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
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_typeLabel(context, t)),
                      selected: _type == t,
                      onSelected: (_) => setState(() => _type = t),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading && list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              ...list.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(width: 36, child: _RankCrown(rank: item.rank)),
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 56,
                        child: Text(
                          '${item.points} P',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    AppLocalizations.of(context).supportPointHint,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  List<({String id, String name, int points, int rank})> _rankingList({
    required AsyncValue<List<UserProfile>> accountAsync,
    required AsyncValue<Map<String, int>> religionAsync,
    required AsyncValue<Map<String, int>> countryAsync,
  }) {
    final notifier = ref.read(testPointProvider);

    switch (_type) {
      // ── 종교별: 로컬(테스트) + 서버(Firestore) 병합 ──
      case RankingType.religion:
        final serverMap = religionAsync.valueOrNull ?? {};
        final combined = <String, int>{};
        // 로컬 포인트 반영
        for (final r in defaultReligions) {
          final pts = notifier.state.getReligionPoints(r.id);
          if (pts > 0) combined[r.id] = (combined[r.id] ?? 0) + pts;
        }
        // 서버 포인트 병합
        for (final entry in serverMap.entries) {
          combined[entry.key] = (combined[entry.key] ?? 0) + entry.value;
        }
        final list = combined.entries
            .map((e) {
              final religion = defaultReligions
                  .cast<Religion?>()
                  .firstWhere((r) => r?.id == e.key, orElse: () => null);
              if (religion == null) return null;
              return (id: e.key, name: religion.name, points: e.value);
            })
            .whereType<({String id, String name, int points})>()
            .toList()
          ..sort((a, b) => b.points.compareTo(a.points));
        return list
            .take(5)
            .toList()
            .asMap()
            .entries
            .map((e) => (
                  id: e.value.id,
                  name: e.value.name,
                  points: e.value.points,
                  rank: e.key + 1,
                ))
            .toList();

      // ── 계정별: 로컬(테스트) + 서버(Firestore) 병합 ──
      case RankingType.account:
        final serverList = accountAsync.valueOrNull ?? <UserProfile>[];
        final localList = notifier.getAccountRanking();
        final combined = <({String id, String name, int points})>[
          ...serverList.map(
              (p) => (id: p.uid, name: p.displayName ?? p.uid, points: p.points)),
          ...localList.map((e) => (id: e.id, name: e.name, points: e.points)),
        ]..sort((a, b) => b.points.compareTo(a.points));
        return combined
            .take(5)
            .toList()
            .asMap()
            .entries
            .map((e) => (
                  id: e.value.id,
                  name: e.value.name,
                  points: e.value.points,
                  rank: e.key + 1,
                ))
            .toList();

      // ── 국가별: 로컬(테스트) + 서버(Firestore) 병합 ──
      case RankingType.country:
        final serverMap = countryAsync.valueOrNull ?? {};
        final combined = <String, int>{};
        // 로컬 포인트 반영
        for (final c in defaultCountries) {
          final pts = notifier.state.getCountryPoints(c.id);
          if (pts > 0) combined[c.id] = (combined[c.id] ?? 0) + pts;
        }
        // 서버 포인트 병합
        for (final entry in serverMap.entries) {
          combined[entry.key] = (combined[entry.key] ?? 0) + entry.value;
        }
        final list = combined.entries
            .map((e) {
              final country = defaultCountries
                  .cast<Country?>()
                  .firstWhere((c) => c?.id == e.key, orElse: () => null);
              if (country == null) return null;
              return (id: e.key, name: country.name, points: e.value);
            })
            .whereType<({String id, String name, int points})>()
            .toList()
          ..sort((a, b) => b.points.compareTo(a.points));
        return list
            .take(5)
            .toList()
            .asMap()
            .entries
            .map((e) => (
                  id: e.value.id,
                  name: e.value.name,
                  points: e.value.points,
                  rank: e.key + 1,
                ))
            .toList();
    }
  }
}

/// 1·2·3위 금·은·동 왕관 아이콘
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
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
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
          colors: [color, Color.lerp(color, Colors.black, 0.25)!],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: rank == 1 ? 8 : 5,
            spreadRadius: 0,
          ),
          const BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Center(
        child: Text('👑', style: TextStyle(fontSize: size - 4, height: 1.0)),
      ),
    );
  }
}
