enum RankingPeriod { today, week, month, all }

enum RankingType { religion, account, country }

/// 기간 탭 라벨 (오늘·이번주·이번달·전체)
const Map<RankingPeriod, String> rankingPeriodLabels = {
  RankingPeriod.today: '오늘',
  RankingPeriod.week: '이번주',
  RankingPeriod.month: '이번달',
  RankingPeriod.all: '전체',
};

/// 타입 탭 라벨 (종교·계정·국가)
const Map<RankingType, String> rankingTypeLabels = {
  RankingType.religion: '종교',
  RankingType.account: '계정',
  RankingType.country: '국가',
};

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
