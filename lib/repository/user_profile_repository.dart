import 'package:cloud_firestore/cloud_firestore.dart';

/// 서버( Firestore ) 사용자 프로필. 계정(uid)과 랭킹 노출용 아이디(displayName) 연동, 중복 검사
class UserProfileRepository {
  UserProfileRepository._();

  static final _store = FirebaseFirestore.instance;
  static const _users = 'users';
  static const _displayNames = 'displayNames';

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
      );
    });
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

  /// 포인트 적립 (로그인 사용자, 계정별 랭킹용). 문서 없으면 생성 후 증가.
  static Future<void> addPoints(String uid, int amount) async {
    if (amount <= 0) return;
    final ref = _store.collection(_users).doc(uid);
    await ref.set({
      'points': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 계정별 랭킹 (아이디(displayName) 있는 사용자만, 포인트 내림차순)
  static Future<List<UserProfile>> getAccountRanking({int limit = 10}) async {
    final all = await _store.collection(_users).get();
    final list = all.docs
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
        .toList();
    list.sort((a, b) => b.points.compareTo(a.points));
    return list.take(limit).toList();
  }
}

class UserProfile {
  final String uid;
  final String? displayName;
  final String? religionId;
  final String? countryId;
  final int points;

  UserProfile({
    required this.uid,
    this.displayName,
    this.religionId,
    this.countryId,
    this.points = 0,
  });
}

enum SetDisplayNameResult { success, duplicate, empty, failure }
