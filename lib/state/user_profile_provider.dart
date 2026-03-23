import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import 'locale_provider.dart';

/// Firebase Auth 상태 스트림 (로그인/로그아웃/계정 변경 시 즉시 반영)
final authUserProvider = StreamProvider((ref) {
  return AuthService.authStateChanges;
});

/// 현재 로그인 사용자 프로필 스트림 (아이디·종교·국가·포인트·언어코드)
/// 프로필 로드 시 Firestore에 저장된 languageCode를 LocaleProvider에 동기화
final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final userAsync = ref.watch(authUserProvider);
  final user = userAsync.valueOrNull;
  if (user == null) return const Stream<UserProfile?>.empty();

  return UserProfileRepository.profileStream(user.uid).map((profile) {
    // 로그인 직후 첫 로드 시 언어 동기화 (SharedPreferences에 없을 때만)
    if (profile?.languageCode != null) {
      ref.read(localeProvider.notifier).syncFromProfile(profile!.languageCode);
    }
    return profile;
  });
});

/// 계정별 랭킹 — 실시간 스트림 (Firestore users 컬렉션 변경 시 자동 반영)
final accountRankingFromServerProvider = StreamProvider<List<UserProfile>>((ref) {
  return UserProfileRepository.accountRankingStream(limit: 10);
});

/// 종교별 포인트 집계 — 실시간 스트림 (religionId → totalPoints)
/// Firestore users 문서가 바뀌면 즉시 재집계
final religionPointsFromServerProvider = StreamProvider<Map<String, int>>((ref) {
  return UserProfileRepository.religionPointsStream();
});

/// 국가별 포인트 집계 — 실시간 스트림 (countryId → totalPoints)
final countryPointsFromServerProvider = StreamProvider<Map<String, int>>((ref) {
  return UserProfileRepository.countryPointsStream();
});

/// 기간별 계정 랭킹 — FutureProvider (기부 직후 ref.invalidate로 갱신)
final accountRankingByPeriodProvider =
    FutureProvider.autoDispose.family<List<UserProfile>, RankingPeriod>((ref, period) {
  return UserProfileRepository.getAccountRankingByPeriod(period: period, limit: 10);
});

/// 기간별 종교 포인트 — StreamProvider (pointEvents 실시간 자동 갱신)
final religionPointsByPeriodProvider =
    StreamProvider.family<Map<String, int>, RankingPeriod>((ref, period) {
  return UserProfileRepository.religionPointsStreamByPeriod(period: period);
});

/// 기간별 국가 포인트 — StreamProvider (pointEvents 실시간 자동 갱신)
final countryPointsByPeriodProvider =
    StreamProvider.family<Map<String, int>, RankingPeriod>((ref, period) {
  return UserProfileRepository.countryPointsStreamByPeriod(period: period);
});
