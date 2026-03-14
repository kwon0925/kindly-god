import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';

/// 현재 로그인 사용자 프로필 스트림 (아이디·종교·국가·포인트)
final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = AuthService.currentUser;
  if (user == null) return Stream.value(null);
  return UserProfileRepository.profileStream(user.uid);
});

/// 계정별 랭킹 (서버 아이디 기준, 포인트 내림차순)
final accountRankingFromServerProvider = FutureProvider<List<UserProfile>>((ref) {
  return UserProfileRepository.getAccountRanking(limit: 10);
});

/// 종교별 포인트 집계 (Firestore users → religionId별 합산)
/// Map<religionId, totalPoints>
final religionPointsFromServerProvider = FutureProvider<Map<String, int>>((ref) {
  return UserProfileRepository.getReligionRankingPoints();
});

/// 국가별 포인트 집계 (Firestore users → countryId별 합산)
/// Map<countryId, totalPoints>
final countryPointsFromServerProvider = FutureProvider<Map<String, int>>((ref) {
  return UserProfileRepository.getCountryRankingPoints();
});
