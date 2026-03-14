import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';

/// 현재 로그인 사용자 프로필 스트림 (아이디·종교·국가·포인트)
final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = AuthService.currentUser;
  if (user == null) return Stream.value(null);
  return UserProfileRepository.profileStream(user.uid);
});

/// 계정별 랭킹 — 실시간 스트림 (Firestore users 컬렉션 변경 시 자동 반영)
final accountRankingFromServerProvider = StreamProvider<List<UserProfile>>((ref) {
  return UserProfileRepository.accountRankingStream(limit: 10);
});

/// 종교별 포인트 집계 — 실시간 스트림 (Map<religionId, totalPoints>)
/// Firestore users 문서가 바뀌면 즉시 재집계
final religionPointsFromServerProvider = StreamProvider<Map<String, int>>((ref) {
  return UserProfileRepository.religionPointsStream();
});

/// 국가별 포인트 집계 — 실시간 스트림 (Map<countryId, totalPoints>)
final countryPointsFromServerProvider = StreamProvider<Map<String, int>>((ref) {
  return UserProfileRepository.countryPointsStream();
});
