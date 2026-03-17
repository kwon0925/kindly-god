import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';

/// Firebase Auth 상태 스트림 (로그인/로그아웃/계정 변경 시 즉시 반영)
final authUserProvider = StreamProvider((ref) {
  return AuthService.authStateChanges;
});

/// 현재 로그인 사용자 프로필 스트림 (아이디·종교·국가·포인트)
final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final userAsync = ref.watch(authUserProvider);
  final user = userAsync.valueOrNull;
  if (user == null) return const Stream<UserProfile?>.empty();
  return UserProfileRepository.profileStream(user.uid);
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
