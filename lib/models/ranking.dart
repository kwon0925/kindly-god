enum RankingPeriod { today, week, month, all }

enum RankingType { religion, account, country }

class RankingItem {
  final String id;
  final String displayName;
  final int rank;
  final int points;

  const RankingItem({
    required this.id,
    required this.displayName,
    required this.rank,
    required this.points,
  });
}
