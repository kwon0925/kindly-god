import 'package:cloud_firestore/cloud_firestore.dart';

/// 서버( Firestore ) 사용자 프로필. 계정(uid)과 랭킹 노출용 아이디(displayName) 연동, 중복 검사
class UserProfileRepository {
  UserProfileRepository._();

  static final _store = FirebaseFirestore.instance;
  static const _users = 'users';
  static const _displayNames = 'displayNames';
  static const _aggregates = 'aggregates';
  static const _pointsTotal = 'pointsTotal';
  static const _religionPoints = 'religionPoints';
  static const _countryPoints = 'countryPoints';

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
      points: (d['points'] as num?)?.toInt() ?? 0,
      profileLocked: d['profileLocked'] as bool? ?? false,
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
        points: (d['points'] as num?)?.toInt() ?? 0,
        profileLocked: d['profileLocked'] as bool? ?? false,
      );
    });
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

  /// 종교별 포인트 집계 실시간 스트림 — 집계 문서 사용 (users 전체 스캔 없음)
  static Stream<Map<String, int>> religionPointsStream() {
    return _store.collection(_aggregates).doc(_religionPoints).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return <String, int>{};
      final d = doc.data()!;
      final map = <String, int>{};
      for (final e in d.entries) {
        if (e.value is num) map[e.key] = (e.value as num).toInt();
      }
      return map;
    });
  }

  /// 국가별 포인트 집계 실시간 스트림 — 집계 문서 사용
  static Stream<Map<String, int>> countryPointsStream() {
    return _store.collection(_aggregates).doc(_countryPoints).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return <String, int>{};
      final d = doc.data()!;
      final map = <String, int>{};
      for (final e in d.entries) {
        if (e.value is num) map[e.key] = (e.value as num).toInt();
      }
      return map;
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
  final int points;
  final bool profileLocked;

  UserProfile({
    required this.uid,
    this.displayName,
    this.religionId,
    this.countryId,
    this.points = 0,
    this.profileLocked = false,
  });
}

enum SetDisplayNameResult { success, duplicate, empty, failure }

/// 아이디 중복 검사만 (저장 안 함). 사용 가능 여부 반환
enum CheckDisplayNameResult { available, duplicate, empty }
