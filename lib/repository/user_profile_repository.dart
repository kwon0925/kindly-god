import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ranking.dart';

/// 서버( Firestore ) 사용자 프로필. 계정(uid)과 랭킹 노출용 아이디(displayName) 연동, 중복 검사
class UserProfileRepository {
  UserProfileRepository._();

  static final _store = FirebaseFirestore.instance;
  static const _users = 'users';
  static const _displayNames = 'displayNames';
  static const _aggregates = 'aggregates';
  static const _pointEvents = 'pointEvents';
  static const _pointsTotal = 'pointsTotal';
  static const _religionPoints = 'religionPoints';
  static const _countryPoints = 'countryPoints';

  static ({DateTime? start, DateTime? end}) _rangeForPeriod(RankingPeriod period) {
    if (period == RankingPeriod.all) return (start: null, end: null);
    final now = DateTime.now();
    switch (period) {
      case RankingPeriod.today:
        final start = DateTime(now.year, now.month, now.day);
        return (start: start, end: start.add(const Duration(days: 1)));
      case RankingPeriod.week:
        final start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - DateTime.monday));
        return (start: start, end: start.add(const Duration(days: 7)));
      case RankingPeriod.month:
        final start = DateTime(now.year, now.month, 1);
        final end = now.month == 12
            ? DateTime(now.year + 1, 1, 1)
            : DateTime(now.year, now.month + 1, 1);
        return (start: start, end: end);
      case RankingPeriod.all:
        return (start: null, end: null);
    }
  }

  /// 아이디 중복 검사·저장 시 사용하는 정규화 (공백 trim, 소문자, 문서 ID용 문자만)
  static String _normalize(String name) {
    return name.trim().toLowerCase().replaceAll(RegExp(r'[/\\\s]+'), '_');
  }

  /// 사용자 프로필 조회
  static Future<UserProfile?> getProfile(String uid) async {
    final doc = await _store.collection(_users).doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    final d = doc.data()!;
    return UserProfile(
      uid: uid,
      displayName: d['displayName'] as String?,
      religionId: d['religionId'] as String?,
      countryId: d['countryId'] as String?,
      role: d['role'] as String?,
      points: (d['points'] as num?)?.toInt() ?? 0,
      profileLocked: d['profileLocked'] as bool? ?? false,
      adWatchCount: (d['adWatchCount'] as num?)?.toInt() ?? 0,
      languageCode: d['languageCode'] as String?,
    );
  }

  /// 프로필 스트림 (실시간 반영)
  static Stream<UserProfile?> profileStream(String uid) {
    return _store.collection(_users).doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      final d = doc.data()!;
      return UserProfile(
        uid: doc.id,
        displayName: d['displayName'] as String?,
        religionId: d['religionId'] as String?,
        countryId: d['countryId'] as String?,
        role: d['role'] as String?,
        points: (d['points'] as num?)?.toInt() ?? 0,
        profileLocked: d['profileLocked'] as bool? ?? false,
        adWatchCount: (d['adWatchCount'] as num?)?.toInt() ?? 0,
        languageCode: d['languageCode'] as String?,
      );
    });
  }

  /// 언어 코드 업데이트 (ProfileLocked와 무관하게 항상 허용)
  static Future<void> updateLanguageCode(String uid, String code) async {
    await _store.collection(_users).doc(uid).set({
      'languageCode': code,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 관리자 권한 부여(테스트/운영자 전환용)
  static Future<void> grantAdminRole({
    required String uid,
    String? email,
  }) async {
    await _store.collection(_users).doc(uid).set({
      'role': 'admin',
      'updatedAt': FieldValue.serverTimestamp(),
      if (email != null && email.isNotEmpty) 'adminEmail': email,
    }, SetOptions(merge: true));
  }

  /// 아이디 중복 검사만 (저장하지 않음)
  static Future<CheckDisplayNameResult> checkDisplayNameAvailable(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return CheckDisplayNameResult.empty;
    final normalized = _normalize(trimmed);
    if (normalized.isEmpty) return CheckDisplayNameResult.empty;
    final ref = _store.collection(_displayNames).doc(normalized);
    final doc = await ref.get();
    if (!doc.exists) return CheckDisplayNameResult.available;
    final existingUid = doc.data()?['uid'] as String?;
    if (existingUid == null) return CheckDisplayNameResult.available;
    return CheckDisplayNameResult.duplicate;
  }

  /// 프로필 잠금 (종교·국가 저장 후 한 번만 호출, 이후 변경 불가)
  static Future<void> lockProfile(String uid) async {
    await _store.collection(_users).doc(uid).set({
      'profileLocked': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 아이디 설정. (결과, 실패 시 메시지)
  static Future<(SetDisplayNameResult, String?)> setDisplayName(String uid, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return (SetDisplayNameResult.empty, null);
    final normalized = _normalize(trimmed);
    if (normalized.isEmpty) return (SetDisplayNameResult.empty, null);

    try {
      final result = await _store.runTransaction<SetDisplayNameResult>((tx) async {
        final ref = _store.collection(_displayNames).doc(normalized);
        final existing = await tx.get(ref);
        if (existing.exists) {
          final existingUid = existing.data()?['uid'] as String?;
          if (existingUid != null && existingUid != uid) return SetDisplayNameResult.duplicate;
        }

        final userRef = _store.collection(_users).doc(uid);
        final userDoc = await tx.get(userRef);
        final oldName = userDoc.data()?['displayName'] as String?;
        final oldNormalized = oldName != null && oldName.trim().isNotEmpty ? _normalize(oldName) : null;

        tx.set(userRef, {
          'displayName': trimmed,
          'updatedAt': FieldValue.serverTimestamp(),
          ...userDoc.data() ?? {},
        }, SetOptions(merge: true));

        tx.set(ref, {'uid': uid});

        if (oldNormalized != null && oldNormalized != normalized) {
          final oldRef = _store.collection(_displayNames).doc(oldNormalized);
          tx.delete(oldRef);
        }
        return SetDisplayNameResult.success;
      });
      return (result, null);
    } on FirebaseException catch (e) {
      return (SetDisplayNameResult.failure, _firestoreMessage(e.code, e.message));
    } catch (e) {
      final msg = e.toString().length > 80 ? '저장에 실패했습니다. 네트워크와 Firestore 규칙을 확인해 주세요.' : e.toString();
      return (SetDisplayNameResult.failure, msg);
    }
  }

  static String _firestoreMessage(String? code, String? message) {
    if (code == 'permission-denied') return '권한이 없습니다. Firestore 규칙을 확인해 주세요.';
    if (message != null && message.isNotEmpty) return message;
    return '저장에 실패했습니다.';
  }

  /// 종교/국가 저장 (로그인 사용자)
  static Future<void> updateReligion(String uid, String religionId) async {
    await _store.collection(_users).doc(uid).set({
      'religionId': religionId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> updateCountry(String uid, String countryId) async {
    await _store.collection(_users).doc(uid).set({
      'countryId': countryId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 포인트 적립: users + 집계(총포인트, 종교별, 국가별) 동시 갱신. 종교/국가 미설정 시 해당 집계는 스킵.
  static Future<void> addPoints(String uid, int amount) async {
    if (amount <= 0) return;
    final userRef = _store.collection(_users).doc(uid);
    final userDoc = await userRef.get();
    final data = userDoc.data();
    final religionId = data?['religionId'] as String?;
    final countryId = data?['countryId'] as String?;

    final batch = _store.batch();

    batch.set(userRef, {
      'points': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final totalRef = _store.collection(_aggregates).doc(_pointsTotal);
    batch.set(totalRef, {'value': FieldValue.increment(amount)}, SetOptions(merge: true));

    if (religionId != null && religionId.isNotEmpty) {
      final relRef = _store.collection(_aggregates).doc(_religionPoints);
      batch.set(relRef, {religionId: FieldValue.increment(amount)}, SetOptions(merge: true));
    }
    if (countryId != null && countryId.isNotEmpty) {
      final ctyRef = _store.collection(_aggregates).doc(_countryPoints);
      batch.set(ctyRef, {countryId: FieldValue.increment(amount)}, SetOptions(merge: true));
    }
    final eventRef = _store.collection(_pointEvents).doc();
    batch.set(eventRef, {
      'uid': uid,
      'type': 'payment',
      'points': amount,
      'amountUsd': amount,
      'religionId': religionId,
      'countryId': countryId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// 광고 시청 포인트: 1회 1P, 10회마다 10P 추가. users + aggregates 동시 갱신.
  static Future<void> addAdWatchPoints(String uid) async {
    final userRef = _store.collection(_users).doc(uid);
    final userDoc = await userRef.get();
    final data = userDoc.data();
    final religionId = data?['religionId'] as String?;
    final countryId = data?['countryId'] as String?;
    final currentCount = (data?['adWatchCount'] as num?)?.toInt() ?? 0;
    final newCount = currentCount + 1;
    int pointsToAdd = 1;
    if (newCount % 10 == 0) pointsToAdd += 10;

    final batch = _store.batch();

    batch.set(userRef, {
      'adWatchCount': newCount,
      'points': FieldValue.increment(pointsToAdd),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final totalRef = _store.collection(_aggregates).doc(_pointsTotal);
    batch.set(totalRef, {'value': FieldValue.increment(pointsToAdd)}, SetOptions(merge: true));

    if (religionId != null && religionId.isNotEmpty) {
      final relRef = _store.collection(_aggregates).doc(_religionPoints);
      batch.set(relRef, {religionId: FieldValue.increment(pointsToAdd)}, SetOptions(merge: true));
    }
    if (countryId != null && countryId.isNotEmpty) {
      final ctyRef = _store.collection(_aggregates).doc(_countryPoints);
      batch.set(ctyRef, {countryId: FieldValue.increment(pointsToAdd)}, SetOptions(merge: true));
    }
    final eventRef = _store.collection(_pointEvents).doc();
    batch.set(eventRef, {
      'uid': uid,
      'type': 'adWatch',
      'points': pointsToAdd,
      'amountUsd': 0,
      'religionId': religionId,
      'countryId': countryId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// 전체 사용자 문서 한 번 조회 (랭킹 집계 공용)
  static Future<List<Map<String, dynamic>>> _allUserDocs() async {
    final snap = await _store.collection(_users).get();
    return snap.docs.map((d) => {'uid': d.id, ...d.data()}).toList();
  }

  /// 계정별 랭킹 (아이디(displayName) 있는 사용자만, 포인트 내림차순)
  static Future<List<UserProfile>> getAccountRanking({int limit = 10}) async {
    final docs = await _allUserDocs();
    final list = docs
        .map((d) {
          final dn = d['displayName'] as String?;
          if (dn == null || dn.trim().isEmpty) return null;
          return UserProfile(
            uid: d['uid'] as String,
            displayName: dn,
            religionId: d['religionId'] as String?,
            countryId: d['countryId'] as String?,
            points: (d['points'] as num?)?.toInt() ?? 0,
          );
        })
        .whereType<UserProfile>()
        .where((p) => p.points > 0)
        .toList()
      ..sort((a, b) => b.points.compareTo(a.points));
    return list.take(limit).toList();
  }

  /// 종교별 포인트 집계 (religionId → 합산 포인트) — 일회성
  static Future<Map<String, int>> getReligionRankingPoints() async {
    final docs = await _allUserDocs();
    return _aggregateByField(docs, 'religionId');
  }

  /// 국가별 포인트 집계 (countryId → 합산 포인트) — 일회성
  static Future<Map<String, int>> getCountryRankingPoints() async {
    final docs = await _allUserDocs();
    return _aggregateByField(docs, 'countryId');
  }

  static Query<Map<String, dynamic>> _periodEventQuery(RankingPeriod period) {
    final range = _rangeForPeriod(period);
    Query<Map<String, dynamic>> query = _store.collection(_pointEvents);
    if (range.start != null && range.end != null) {
      query = query
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(range.start!.toUtc()))
          .where('createdAt', isLessThan: Timestamp.fromDate(range.end!.toUtc()));
    }
    return query;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> _periodEventSnapshot(RankingPeriod period) {
    return _periodEventQuery(period).get();
  }

  /// 종교별 기간 포인트 실시간 스트림
  static Stream<Map<String, int>> religionPointsStreamByPeriod({required RankingPeriod period}) {
    if (period == RankingPeriod.all) return religionPointsStream();
    return _periodEventQuery(period).snapshots().map((snap) {
      final totals = <String, int>{};
      for (final doc in snap.docs) {
        final d = doc.data();
        final id = d['religionId'] as String?;
        final pts = (d['points'] as num?)?.toInt() ?? 0;
        if (id == null || id.isEmpty || pts <= 0) continue;
        totals[id] = (totals[id] ?? 0) + pts;
      }
      return totals;
    });
  }

  /// 국가별 기간 포인트 실시간 스트림
  static Stream<Map<String, int>> countryPointsStreamByPeriod({required RankingPeriod period}) {
    if (period == RankingPeriod.all) return countryPointsStream();
    return _periodEventQuery(period).snapshots().map((snap) {
      final totals = <String, int>{};
      for (final doc in snap.docs) {
        final d = doc.data();
        final id = d['countryId'] as String?;
        final pts = (d['points'] as num?)?.toInt() ?? 0;
        if (id == null || id.isEmpty || pts <= 0) continue;
        totals[id] = (totals[id] ?? 0) + pts;
      }
      return totals;
    });
  }

  static Future<List<UserProfile>> getAccountRankingByPeriod({
    required RankingPeriod period,
    int limit = 10,
  }) async {
    if (period == RankingPeriod.all) {
      return getAccountRanking(limit: limit);
    }
    final snap = await _periodEventSnapshot(period);
    final totals = <String, int>{};
    for (final doc in snap.docs) {
      final d = doc.data();
      final uid = d['uid'] as String?;
      final pts = (d['points'] as num?)?.toInt() ?? 0;
      if (uid == null || uid.isEmpty || pts <= 0) continue;
      totals[uid] = (totals[uid] ?? 0) + pts;
    }
    final list = <UserProfile>[];
    for (final entry in totals.entries) {
      final userDoc = await _store.collection(_users).doc(entry.key).get();
      final d = userDoc.data() ?? {};
      final dn = d['displayName'] as String?;
      if (dn == null || dn.trim().isEmpty) continue;
      list.add(UserProfile(
        uid: entry.key,
        displayName: dn,
        religionId: d['religionId'] as String?,
        countryId: d['countryId'] as String?,
        role: d['role'] as String?,
        points: entry.value,
      ));
    }
    list.sort((a, b) => b.points.compareTo(a.points));
    return list.take(limit).toList();
  }

  static Future<Map<String, int>> getReligionRankingPointsByPeriod({
    required RankingPeriod period,
  }) async {
    if (period == RankingPeriod.all) return getReligionRankingPoints();
    final snap = await _periodEventSnapshot(period);
    final totals = <String, int>{};
    for (final doc in snap.docs) {
      final d = doc.data();
      final id = d['religionId'] as String?;
      final pts = (d['points'] as num?)?.toInt() ?? 0;
      if (id == null || id.isEmpty || pts <= 0) continue;
      totals[id] = (totals[id] ?? 0) + pts;
    }
    return totals;
  }

  static Future<Map<String, int>> getCountryRankingPointsByPeriod({
    required RankingPeriod period,
  }) async {
    if (period == RankingPeriod.all) return getCountryRankingPoints();
    final snap = await _periodEventSnapshot(period);
    final totals = <String, int>{};
    for (final doc in snap.docs) {
      final d = doc.data();
      final id = d['countryId'] as String?;
      final pts = (d['points'] as num?)?.toInt() ?? 0;
      if (id == null || id.isEmpty || pts <= 0) continue;
      totals[id] = (totals[id] ?? 0) + pts;
    }
    return totals;
  }

  // ── 실시간 스트림 (Firestore snapshots 사용) ──────────────────────────

  /// 계정별 랭킹 실시간 스트림
  static Stream<List<UserProfile>> accountRankingStream({int limit = 10}) {
    return _store.collection(_users).snapshots().map((snap) {
      final list = snap.docs
          .map((d) {
            final data = d.data();
            final dn = data['displayName'] as String?;
            if (dn == null || dn.trim().isEmpty) return null;
            return UserProfile(
              uid: d.id,
              displayName: dn,
              religionId: data['religionId'] as String?,
              countryId: data['countryId'] as String?,
              points: (data['points'] as num?)?.toInt() ?? 0,
            );
          })
          .whereType<UserProfile>()
          .where((p) => p.points > 0)
          .toList()
        ..sort((a, b) => b.points.compareTo(a.points));
      return list.take(limit).toList();
    });
  }

  /// 종교별 포인트 집계 실시간 스트림 — users 컬렉션 기준 (비로그인도 조회 가능, 과거 기부 포함)
  static Stream<Map<String, int>> religionPointsStream() {
    return _store.collection(_users).snapshots().map((snap) {
      final docs = snap.docs.map((d) => {'uid': d.id, ...d.data()}).toList();
      return _aggregateByField(docs, 'religionId');
    });
  }

  /// 국가별 포인트 집계 실시간 스트림 — users 컬렉션 기준
  static Stream<Map<String, int>> countryPointsStream() {
    return _store.collection(_users).snapshots().map((snap) {
      final docs = snap.docs.map((d) => {'uid': d.id, ...d.data()}).toList();
      return _aggregateByField(docs, 'countryId');
    });
  }

  /// fieldId별 points 합산 헬퍼
  static Map<String, int> _aggregateByField(
      List<Map<String, dynamic>> docs, String field) {
    final totals = <String, int>{};
    for (final d in docs) {
      final id = d[field] as String?;
      final pts = (d['points'] as num?)?.toInt() ?? 0;
      if (id != null && pts > 0) {
        totals[id] = (totals[id] ?? 0) + pts;
      }
    }
    return totals;
  }
}

class UserProfile {
  final String uid;
  final String? displayName;
  final String? religionId;
  final String? countryId;
  final String? role;
  final int points;
  final bool profileLocked;
  final int adWatchCount;
  final String? languageCode;

  UserProfile({
    required this.uid,
    this.displayName,
    this.religionId,
    this.countryId,
    this.role,
    this.points = 0,
    this.profileLocked = false,
    this.adWatchCount = 0,
    this.languageCode,
  });
}

enum SetDisplayNameResult { success, duplicate, empty, failure }

/// 아이디 중복 검사만 (저장 안 함). 사용 가능 여부 반환
enum CheckDisplayNameResult { available, duplicate, empty }
